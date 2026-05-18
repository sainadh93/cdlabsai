#!/usr/bin/env python3
"""
clone_detector.py — Cross-Language Code Clone Detector via LLVM IR

Usage:
    python clone_detector.py detect --inputs <file1.ll> [file2.ll ...] [--threshold 0.75]
    python clone_detector.py compile-and-detect --sources <dir/> [--langs c,cpp,rust]
    python clone_detector.py evaluate --corpus <corpus_dir/>

Options:
    --threshold FLOAT     Similarity threshold for clone reporting (default: 0.75)
    --output FORMAT       Output format: text|json|csv (default: text)
    --cross-lang          Only report cross-language clone pairs
    --min-bb INT          Minimum basic block count to include function (default: 2)
    --verbose             Print per-function fingerprint details
"""

import argparse
import json
import os
import sys
import csv
import subprocess
import time
from pathlib import Path
from typing import List, Optional

sys.path.insert(0, os.path.dirname(__file__))
from normalizer.ir_normalizer import normalize_file, NormalizedFunction
from fingerprint.fingerprint_engine import (
    fingerprint_functions, find_clone_pairs,
    FunctionFingerprint, FingerprintEngine, SimilarityScorer
)

BANNER = """
╔══════════════════════════════════════════════════════════════╗
║    Cross-Language Code Clone Detector via LLVM IR            ║
║    Supports: C  C++  Rust  Fortran                           ║
╚══════════════════════════════════════════════════════════════╝
"""

# Language → compiler command
COMPILERS = {
    'c':       ['clang', '-S', '-emit-llvm', '-O1', '-o', '{out}', '{src}'],
    'cpp':     ['clang++', '-S', '-emit-llvm', '-O1', '-o', '{out}', '{src}'],
    'rust':    ['rustc', '--emit=llvm-ir', '-C', 'opt-level=1', '-o', '{out}', '{src}'],
    'fortran': ['flang', '-S', '-emit-llvm', '-O1', '-o', '{out}', '{src}'],
}

EXT_TO_LANG = {
    '.c': 'c', '.cpp': 'cpp', '.cc': 'cpp', '.cxx': 'cpp',
    '.rs': 'rust',
    '.f90': 'fortran', '.f': 'fortran', '.f95': 'fortran', '.for': 'fortran',
    '.ll': 'llvm-ir',  # Pre-compiled IR
}


def compile_to_ir(src_path: str, out_dir: str) -> Optional[str]:
    """Compile a source file to LLVM IR. Returns path to .ll file or None on error."""
    ext = Path(src_path).suffix.lower()
    lang = EXT_TO_LANG.get(ext)
    if not lang or lang == 'llvm-ir':
        return src_path if lang == 'llvm-ir' else None

    out_path = os.path.join(out_dir, Path(src_path).stem + f'_{lang}.ll')
    cmd = COMPILERS[lang]
    cmd = [c.replace('{out}', out_path).replace('{src}', src_path) for c in cmd]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            print(f"  [WARN] Compilation failed for {src_path}: {result.stderr[:200]}")
            return None
        return out_path
    except FileNotFoundError:
        print(f"  [WARN] Compiler not found for {lang}. Using mock IR for demonstration.")
        return _generate_mock_ir(src_path, out_path, lang)
    except subprocess.TimeoutExpired:
        print(f"  [WARN] Compilation timed out for {src_path}")
        return None


def _generate_mock_ir(src_path: str, out_path: str, lang: str) -> str:
    """
    Generate mock IR from source when compiler is unavailable.
    Parses function signatures and generates plausible IR for demo/testing.
    """
    import re

    with open(src_path, 'r', errors='replace') as f:
        src = f.read()

    # Simple heuristic: extract function names and generate IR stubs
    if lang in ('c', 'cpp'):
        func_pattern = re.compile(r'\b(?:int|float|double|void|long|char)\s+(\w+)\s*\(([^)]*)\)\s*\{', re.MULTILINE)
    elif lang == 'rust':
        func_pattern = re.compile(r'\bfn\s+(\w+)\s*\(([^)]*)\)', re.MULTILINE)
    elif lang == 'fortran':
        func_pattern = re.compile(r'\b(?:FUNCTION|SUBROUTINE)\s+(\w+)\s*\(([^)]*)\)', re.MULTILINE | re.IGNORECASE)
    else:
        func_pattern = None

    ir_lines = [
        f'; ModuleID = \'{src_path}\'',
        f'source_filename = "{src_path}"',
        'target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"',
        'target triple = "x86_64-pc-linux-gnu"',
        '',
    ]

    if func_pattern:
        for m in func_pattern.finditer(src):
            fname = m.group(1)
            params_raw = m.group(2).strip()
            # Parse params: generate i32 for each
            param_list = [p.strip() for p in params_raw.split(',') if p.strip()]
            param_count = len(param_list)
            params_ir = ', '.join([f'i32 %p{i}' for i in range(param_count)])

            # Try to parse body for basic structure
            body_start = m.end()
            depth = 1
            pos = body_start
            while pos < len(src) and depth > 0:
                if src[pos] == '{':
                    depth += 1
                elif src[pos] == '}':
                    depth -= 1
                pos += 1
            body = src[body_start:pos - 1]

            # Heuristic: count loops, branches, arithmetic
            has_loop = bool(re.search(r'\b(for|while|do)\b', body))
            has_branch = bool(re.search(r'\bif\b', body))
            has_arith = bool(re.search(r'[+\-*/]', body))

            # Generate representative IR
            ir_lines += _emit_mock_function(fname, params_ir, param_count,
                                            has_loop, has_branch, has_arith, lang)

    os.makedirs(os.path.dirname(out_path) or '.', exist_ok=True)
    with open(out_path, 'w') as f:
        f.write('\n'.join(ir_lines))
    return out_path


def _emit_mock_function(name: str, params_ir: str, param_count: int,
                        has_loop: bool, has_branch: bool, has_arith: bool,
                        lang: str) -> List[str]:
    """Emit a plausible mock LLVM IR function body for demonstration."""
    lines = [f'define i32 @{name}({params_ir}) {{']
    lines.append('entry:')
    lines.append('  %result = alloca i32, align 4')
    lines.append('  store i32 0, i32* %result, align 4')

    if has_arith:
        for i in range(min(param_count, 3)):
            lines.append(f'  %tmp{i} = add i32 %p{i}, 1')
            lines.append(f'  %tmp{i}a = mul i32 %tmp{i}, 2')

    if has_branch:
        lines += [
            '  %cmp = icmp sgt i32 %p0, 0',
            '  br i1 %cmp, label %if.then, label %if.else',
            'if.then:',
            '  %tv = add i32 1, 0',
            '  br label %if.end',
            'if.else:',
            '  %fv = add i32 0, 0',
            '  br label %if.end',
            'if.end:',
            '  %rv = phi i32 [ %tv, %if.then ], [ %fv, %if.else ]',
        ]

    if has_loop:
        lines += [
            '  %i = alloca i32, align 4',
            '  store i32 0, i32* %i, align 4',
            '  br label %loop.cond',
            'loop.cond:',
            '  %iv = load i32, i32* %i, align 4',
            '  %lc = icmp slt i32 %iv, 10',
            '  br i1 %lc, label %loop.body, label %loop.end',
            'loop.body:',
            '  %iv2 = add i32 %iv, 1',
            '  store i32 %iv2, i32* %i, align 4',
            '  br label %loop.cond',
            'loop.end:',
        ]

    lines += [
        '  %retval = load i32, i32* %result, align 4',
        '  ret i32 %retval',
        '}',
        '',
    ]
    return lines


def load_ir_files(ir_paths: List[str], min_bb: int = 2) -> List[NormalizedFunction]:
    """Load and normalize all IR files, filtering tiny functions."""
    functions = []
    for ir_path in ir_paths:
        if not os.path.exists(ir_path):
            print(f"  [WARN] File not found: {ir_path}")
            continue
        try:
            funcs = normalize_file(ir_path, ir_path)
            before = len(funcs)
            funcs = [f for f in funcs if len(f.basic_blocks) >= min_bb]
            print(f"  Loaded {ir_path}: {before} functions ({len(funcs)} after min_bb={min_bb} filter)")
            functions.extend(funcs)
        except Exception as e:
            print(f"  [ERROR] Failed to process {ir_path}: {e}")
    return functions


def format_output_text(clone_pairs, threshold: float, elapsed: float) -> str:
    """Format clone pairs as human-readable text."""
    lines = []
    lines.append(f"\n{'='*68}")
    lines.append(f"  Clone Detection Results  (threshold={threshold}, {elapsed:.2f}s)")
    lines.append(f"{'='*68}")

    if not clone_pairs:
        lines.append("  No clone pairs found above threshold.")
        return '\n'.join(lines)

    lines.append(f"  Found {len(clone_pairs)} clone pair(s):\n")

    for i, (fp1, fp2, score, details) in enumerate(clone_pairs, 1):
        lang_pair = f"{fp1.source_lang}↔{fp2.source_lang}"
        cross = " [CROSS-LANGUAGE]" if fp1.source_lang != fp2.source_lang else ""
        lines.append(f"  ┌─ Clone Pair #{i} {cross}")
        lines.append(f"  │  Score:  {score:.4f}  ({lang_pair})")
        lines.append(f"  │  Func A: {fp1.func_name}")
        lines.append(f"  │          {fp1.source_file}")
        lines.append(f"  │  Func B: {fp2.func_name}")
        lines.append(f"  │          {fp2.source_file}")
        lines.append(f"  │  Metrics:")
        lines.append(f"  │    Structural: {details['structural']:.4f}  Opcode: {details['opcode']:.4f}")
        lines.append(f"  │    CFG:        {details['cfg']:.4f}  Params: {details['params']:.4f}")
        wl_tag = " ✓ (WL-hash match)" if details.get('wl_hash_match') else ""
        lines.append(f"  │    WL-Hash:   {wl_tag if wl_tag else 'no exact match'}")
        lines.append(f"  │  Stats A: {fp1.bb_count} blocks, CC={fp1.cyclomatic_complexity}, "
                     f"{'loop' if fp1.has_loop else 'no-loop'}")
        lines.append(f"  │  Stats B: {fp2.bb_count} blocks, CC={fp2.cyclomatic_complexity}, "
                     f"{'loop' if fp2.has_loop else 'no-loop'}")
        lines.append(f"  └{'─'*64}")

    return '\n'.join(lines)


def format_output_json(clone_pairs) -> str:
    """Format clone pairs as JSON."""
    result = []
    for fp1, fp2, score, details in clone_pairs:
        result.append({
            'score': score,
            'cross_language': fp1.source_lang != fp2.source_lang,
            'function_a': {
                'name': fp1.func_name,
                'file': fp1.source_file,
                'lang': fp1.source_lang,
                'bb_count': fp1.bb_count,
                'cyclomatic_complexity': fp1.cyclomatic_complexity,
                'has_loop': fp1.has_loop,
            },
            'function_b': {
                'name': fp2.func_name,
                'file': fp2.source_file,
                'lang': fp2.source_lang,
                'bb_count': fp2.bb_count,
                'cyclomatic_complexity': fp2.cyclomatic_complexity,
                'has_loop': fp2.has_loop,
            },
            'metric_breakdown': details,
        })
    return json.dumps({'clone_pairs': result}, indent=2)


def format_output_csv(clone_pairs) -> str:
    """Format clone pairs as CSV."""
    import io
    buf = io.StringIO()
    writer = csv.writer(buf)
    writer.writerow(['score', 'lang_a', 'lang_b', 'func_a', 'file_a', 'func_b', 'file_b',
                     'structural', 'opcode', 'cfg', 'params', 'wl_match'])
    for fp1, fp2, score, details in clone_pairs:
        writer.writerow([score, fp1.source_lang, fp2.source_lang,
                         fp1.func_name, fp1.source_file,
                         fp2.func_name, fp2.source_file,
                         details['structural'], details['opcode'],
                         details['cfg'], details['params'],
                         details.get('wl_hash_match', False)])
    return buf.getvalue()


def cmd_detect(args):
    """Run detection on pre-compiled IR files."""
    print(BANNER)
    print(f"[*] Loading {len(args.inputs)} IR file(s)...")

    functions = load_ir_files(args.inputs, min_bb=args.min_bb)
    if not functions:
        print("[ERROR] No functions loaded. Check input files.")
        sys.exit(1)

    print(f"\n[*] Fingerprinting {len(functions)} function(s)...")
    t0 = time.time()
    fingerprints = fingerprint_functions(functions)
    t1 = time.time()

    if args.verbose:
        for fp in fingerprints:
            print(f"  {fp.func_name} ({fp.source_lang}): bb={fp.bb_count} cc={fp.cyclomatic_complexity} "
                  f"loop={fp.has_loop} phi={fp.phi_count} calls={fp.call_count} wl={fp.wl_hash}")

    print(f"[*] Finding clone pairs (threshold={args.threshold})...")
    pairs = find_clone_pairs(fingerprints, threshold=args.threshold,
                             cross_language_only=args.cross_lang)
    elapsed = time.time() - t0

    if args.output == 'json':
        print(format_output_json(pairs))
    elif args.output == 'csv':
        print(format_output_csv(pairs))
    else:
        print(format_output_text(pairs, args.threshold, elapsed))

    # Save results
    if args.save:
        os.makedirs(os.path.dirname(args.save) or '.', exist_ok=True)
        ext = Path(args.save).suffix.lower()
        if ext == '.json':
            content = format_output_json(pairs)
        elif ext == '.csv':
            content = format_output_csv(pairs)
        else:
            content = format_output_text(pairs, args.threshold, elapsed)
        with open(args.save, 'w') as f:
            f.write(content)
        print(f"\n[*] Results saved to {args.save}")


def cmd_compile_and_detect(args):
    """Compile sources to IR then run detection."""
    print(BANNER)
    src_dir = args.sources
    if not os.path.isdir(src_dir):
        print(f"[ERROR] Directory not found: {src_dir}")
        sys.exit(1)

    tmp_dir = '/tmp/clone_detector_ir'
    os.makedirs(tmp_dir, exist_ok=True)

    # Find all source files
    src_files = []
    for ext in EXT_TO_LANG:
        src_files.extend(Path(src_dir).rglob(f'*{ext}'))

    if args.langs:
        allowed = set(args.langs.split(','))
        src_files = [f for f in src_files if EXT_TO_LANG.get(f.suffix.lower()) in allowed]

    print(f"[*] Found {len(src_files)} source file(s). Compiling to IR...")
    ir_files = []
    for src in src_files:
        print(f"  Compiling {src}...")
        ir_path = compile_to_ir(str(src), tmp_dir)
        if ir_path:
            ir_files.append(ir_path)

    # Delegate to detect
    args.inputs = ir_files
    if not hasattr(args, 'min_bb'):
        args.min_bb = 2
    if not hasattr(args, 'save'):
        args.save = None
    cmd_detect(args)


def cmd_evaluate(args):
    """Run evaluation on a corpus with known clone pairs."""
    print(BANNER)
    print(f"[*] Running evaluation on corpus: {args.corpus}")

    corpus_dir = args.corpus
    if not os.path.isdir(corpus_dir):
        print(f"[ERROR] Corpus directory not found: {corpus_dir}")
        sys.exit(1)

    # Load expected clone pairs from corpus/expected/*.json
    expected_dir = os.path.join(corpus_dir, 'expected')
    results = {'true_positives': 0, 'false_positives': 0, 'false_negatives': 0,
                'test_cases': [], 'total_pairs_detected': 0}

    # Find all IR files in corpus
    ir_files = list(Path(corpus_dir).rglob('*.ll'))
    print(f"[*] Found {len(ir_files)} IR files in corpus.")

    if not ir_files:
        print("[WARN] No .ll files found. Generating from testcases directory...")
        ir_files = _generate_corpus_ir(corpus_dir)

    functions = load_ir_files([str(f) for f in ir_files], min_bb=1)
    fingerprints = fingerprint_functions(functions)
    detected_pairs = find_clone_pairs(fingerprints, threshold=args.threshold)
    results['total_pairs_detected'] = len(detected_pairs)

    # Load expected pairs
    expected_pairs = []
    if os.path.isdir(expected_dir):
        for ef in Path(expected_dir).glob('*.json'):
            with open(ef) as f:
                expected_pairs.extend(json.load(f).get('clone_pairs', []))

    # Compare detected vs expected
    for ep in expected_pairs:
        fa, fb = ep['func_a'], ep['func_b']
        found = any((fp1.func_name == fa and fp2.func_name == fb) or
                    (fp1.func_name == fb and fp2.func_name == fa)
                    for fp1, fp2, _, _ in detected_pairs)
        if found:
            results['true_positives'] += 1
        else:
            results['false_negatives'] += 1

    # Detected pairs not in expected
    for fp1, fp2, score, _ in detected_pairs:
        fa, fb = fp1.func_name, fp2.func_name
        in_expected = any((ep.get('func_a') == fa and ep.get('func_b') == fb) or
                          (ep.get('func_a') == fb and ep.get('func_b') == fa)
                          for ep in expected_pairs)
        if not in_expected:
            results['false_positives'] += 1

    # Compute metrics
    tp, fp, fn = results['true_positives'], results['false_positives'], results['false_negatives']
    precision = tp / max(tp + fp, 1)
    recall = tp / max(tp + fn, 1)
    f1 = 2 * precision * recall / max(precision + recall, 1e-9)

    print(f"\n{'='*50}")
    print(f"  EVALUATION RESULTS")
    print(f"{'='*50}")
    print(f"  Functions analyzed:  {len(fingerprints)}")
    print(f"  Pairs detected:      {results['total_pairs_detected']}")
    print(f"  Expected pairs:      {len(expected_pairs)}")
    print(f"  True Positives:      {tp}")
    print(f"  False Positives:     {fp}")
    print(f"  False Negatives:     {fn}")
    print(f"  Precision:           {precision:.3f}")
    print(f"  Recall:              {recall:.3f}")
    print(f"  F1 Score:            {f1:.3f}")
    print(f"{'='*50}")

    # Save evaluation results
    eval_out = os.path.join(args.corpus, 'evaluation_results.json')
    with open(eval_out, 'w') as f:
        json.dump({
            'threshold': args.threshold,
            'functions_analyzed': len(fingerprints),
            'precision': precision,
            'recall': recall,
            'f1': f1,
            'true_positives': tp,
            'false_positives': fp,
            'false_negatives': fn,
            'detected_pairs': [
                {'func_a': fp1.func_name, 'lang_a': fp1.source_lang,
                 'func_b': fp2.func_name, 'lang_b': fp2.source_lang,
                 'score': score,
                 'cross_language': fp1.source_lang != fp2.source_lang}
                for fp1, fp2, score, _ in detected_pairs
            ]
        }, f, indent=2)
    print(f"\n[*] Evaluation results saved to {eval_out}")


def _generate_corpus_ir(corpus_dir: str) -> List[Path]:
    """Generate IR files from testcase sources within the corpus."""
    src_files = []
    for ext in ['.c', '.cpp', '.rs', '.f90']:
        src_files.extend(Path(corpus_dir).rglob(f'*{ext}'))

    tmp_dir = '/tmp/clone_detector_corpus_ir'
    os.makedirs(tmp_dir, exist_ok=True)
    ir_files = []
    for src in src_files:
        ir_path = compile_to_ir(str(src), tmp_dir)
        if ir_path:
            ir_files.append(Path(ir_path))
    return ir_files


def main():
    parser = argparse.ArgumentParser(
        description='Cross-Language Code Clone Detector via LLVM IR',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    sub = parser.add_subparsers(dest='command', required=True)

    # detect subcommand
    p_detect = sub.add_parser('detect', help='Detect clones in pre-compiled IR files')
    p_detect.add_argument('--inputs', nargs='+', required=True, help='Input .ll IR files')
    p_detect.add_argument('--threshold', type=float, default=0.75, help='Similarity threshold')
    p_detect.add_argument('--output', choices=['text', 'json', 'csv'], default='text')
    p_detect.add_argument('--cross-lang', action='store_true', help='Only cross-language pairs')
    p_detect.add_argument('--min-bb', type=int, default=2, help='Min basic blocks per function')
    p_detect.add_argument('--verbose', action='store_true')
    p_detect.add_argument('--save', default=None, help='Save results to file')
    p_detect.set_defaults(func=cmd_detect)

    # compile-and-detect subcommand
    p_cad = sub.add_parser('compile-and-detect', help='Compile sources then detect clones')
    p_cad.add_argument('--sources', required=True, help='Directory of source files')
    p_cad.add_argument('--langs', default=None, help='Comma-separated: c,cpp,rust,fortran')
    p_cad.add_argument('--threshold', type=float, default=0.75)
    p_cad.add_argument('--output', choices=['text', 'json', 'csv'], default='text')
    p_cad.add_argument('--cross-lang', action='store_true')
    p_cad.add_argument('--min-bb', type=int, default=2)
    p_cad.add_argument('--verbose', action='store_true')
    p_cad.add_argument('--save', default=None)
    p_cad.set_defaults(func=cmd_compile_and_detect)

    # evaluate subcommand
    p_eval = sub.add_parser('evaluate', help='Evaluate against a labeled corpus')
    p_eval.add_argument('--corpus', required=True, help='Corpus directory')
    p_eval.add_argument('--threshold', type=float, default=0.75)
    p_eval.set_defaults(func=cmd_evaluate)

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
