#!/usr/bin/env python3
"""
IR Normalizer: Strips language-specific artifacts from LLVM IR.
Handles C, C++, Rust, Fortran differences in naming, metadata, and attributes.
"""

import re
import sys
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple


@dataclass
class NormalizedFunction:
    name: str
    original_name: str
    source_lang: str
    source_file: str
    basic_blocks: List[str] = field(default_factory=list)
    instructions: List[str] = field(default_factory=list)
    normalized_ir: str = ""
    param_count: int = 0
    return_type: str = "void"


class IRNormalizer:
    """
    Normalizes LLVM IR across languages by:
    1. Demangle C++/Rust mangled names
    2. Strip language-specific metadata (Fortran array descriptors, C++ vtables, Rust drop glue)
    3. Normalize types (i32 vs i64 platform differences)
    4. Anonymize SSA register names
    5. Remove debug info and attributes
    """

    # Regex patterns for IR parsing
    FUNC_DEF = re.compile(
        r'^define\s+(?:(?:internal|external|private|linkonce|weak|common|appending|extern_weak|linkonce_odr|weak_odr|available_externally)\s+)*'
        r'(?:(?:default|hidden|protected)\s+)?'
        r'(?:dso_local\s+)?'
        r'(\S+)\s+@([^\s(]+)\s*\(([^)]*)\)',
        re.MULTILINE
    )
    LABEL = re.compile(r'^(\w+):')
    SSA_REG = re.compile(r'%(\d+)')
    NAMED_REG = re.compile(r'%([a-zA-Z_][a-zA-Z0-9_.]+)')
    METADATA = re.compile(r',?\s*![\w.]+\s*!?\d*')
    ATTRIBUTES = re.compile(r'\s*#\d+')
    ALIGN = re.compile(r',\s*align\s+\d+')
    DEBUG_LOC = re.compile(r'call void @llvm\.dbg\..+')
    LIFETIME = re.compile(r'call void @llvm\.lifetime\..+')
    FORTRAN_DESC = re.compile(r'%struct\.__array_descriptor\w*')
    RUST_DROP = re.compile(r'@_ZN\w+4drop\w*')
    CPP_VTABLE = re.compile(r'@_ZTV\w+')
    DECLARE_LINE = re.compile(r'^declare\s+.+$', re.MULTILINE)
    ATTR_GROUP = re.compile(r'^attributes\s+#\d+\s*=\s*\{[^}]*\}', re.MULTILINE)
    TARGET_INFO = re.compile(r'^(target datalayout|target triple)\s*=.+$', re.MULTILINE)
    SOURCE_FILENAME = re.compile(r'^source_filename\s*=.+$', re.MULTILINE)
    GLOBAL_META = re.compile(r'^!\d+\s*=.+$', re.MULTILINE)
    NAMED_META = re.compile(r'^!\w+\s*=.+$', re.MULTILINE)
    TYPE_I64_PARAM = re.compile(r'\bi64\b')
    TYPE_I32_PARAM = re.compile(r'\bi32\b')

    # Language detection heuristics
    LANG_PATTERNS = {
        'rust': [r'@_ZN\w+', r'@rust_', r'core::', r'std::', r'alloc::'],
        'cpp': [r'@_Z[A-Z]', r'@_ZN', r'@_ZTV', r'cxx', r'std::'],
        'fortran': [r'@__', r'_mp_', r'_$', r'fortran'],
        'c': [],  # fallback
    }

    def __init__(self, normalize_types: bool = True, strip_debug: bool = True):
        self.normalize_types = normalize_types
        self.strip_debug = strip_debug

    def detect_language(self, ir_text: str, filename: str = "") -> str:
        """Heuristically detect source language from IR patterns."""
        fname_lower = filename.lower()
        if fname_lower.endswith('.rs'):
            return 'rust'
        if fname_lower.endswith(('.f90', '.f', '.f95', '.for')):
            return 'fortran'
        if fname_lower.endswith(('.cc', '.cpp', '.cxx', '.C')):
            return 'cpp'

        # Pattern-based detection
        for lang, patterns in self.LANG_PATTERNS.items():
            if lang == 'c':
                continue
            for p in patterns:
                if re.search(p, ir_text):
                    return lang
        return 'c'

    def demangle_name(self, mangled: str, lang: str) -> str:
        """
        Simplified demangling for normalization purposes.
        Full demangling uses c++filt / rustfilt via subprocess in production.
        Here we do structural normalization.
        """
        name = mangled.lstrip('@').lstrip('"').rstrip('"')

        # Strip Rust-specific suffixes (hash ids like h1a2b3c4d)
        name = re.sub(r'::h[0-9a-f]{16}$', '', name)
        name = re.sub(r'_[0-9a-f]{17}$', '', name)

        # Strip Fortran module prefixes
        name = re.sub(r'^__\w+_MOD_', '', name)

        # Strip C++ mangling prefix (_ZN...E patterns → keep last component)
        if name.startswith('_ZN'):
            parts = re.findall(r'\d+(\w+)', name)
            if parts:
                name = '::'.join(parts)

        # Remove leading underscores (platform ABI)
        name = name.lstrip('_').replace('.', '_')
        return name if name else mangled

    def normalize_types_in_line(self, line: str) -> str:
        """Normalize platform-specific types (i64<->i32 for pointer-sized ints)."""
        if not self.normalize_types:
            return line
        # Normalize pointer-width integers — treat i32/i64 as equivalent for comparison
        line = re.sub(r'\bi(32|64)\b', 'iN', line)
        return line

    def anonymize_registers(self, instructions: List[str]) -> List[str]:
        """Replace SSA register names with sequential anonymous names."""
        reg_map: Dict[str, str] = {}
        counter = [0]

        def get_reg(name: str) -> str:
            if name not in reg_map:
                reg_map[name] = f'%r{counter[0]}'
                counter[0] += 1
            return reg_map[name]

        result = []
        for line in instructions:
            # Replace %name = ... (definition)
            def replace_reg(m):
                return get_reg(m.group(0))
            line = re.sub(r'%[\w.]+', replace_reg, line)
            result.append(line)
        return result

    def strip_metadata(self, line: str) -> str:
        """Remove LLVM metadata references from a line."""
        line = self.METADATA.sub('', line)
        line = self.ATTRIBUTES.sub('', line)
        line = self.ALIGN.sub('', line)
        return line.rstrip()

    def extract_functions(self, ir_text: str, source_file: str = "") -> List[NormalizedFunction]:
        """Extract and normalize all function definitions from IR text."""
        lang = self.detect_language(ir_text, source_file)
        functions = []

        # Split into function blocks
        func_blocks = self._split_functions(ir_text)

        for block in func_blocks:
            func = self._normalize_function(block, lang, source_file)
            if func:
                functions.append(func)

        return functions

    def _split_functions(self, ir_text: str) -> List[str]:
        """Split IR text into individual function definition blocks."""
        blocks = []
        lines = ir_text.split('\n')
        current_block = []
        in_func = False
        brace_depth = 0

        for line in lines:
            stripped = line.strip()
            if stripped.startswith('define ') and '{' in stripped:
                in_func = True
                brace_depth = stripped.count('{') - stripped.count('}')
                current_block = [line]
            elif in_func:
                current_block.append(line)
                brace_depth += stripped.count('{') - stripped.count('}')
                if brace_depth <= 0:
                    in_func = False
                    blocks.append('\n'.join(current_block))
                    current_block = []

        return blocks

    def _normalize_function(self, block: str, lang: str, source_file: str) -> Optional[NormalizedFunction]:
        """Normalize a single function block."""
        lines = block.split('\n')
        if not lines:
            return None

        # Parse function signature
        header = lines[0]
        match = re.search(r'@([^\s(]+)', header)
        if not match:
            return None

        raw_name = match.group(1)
        clean_name = self.demangle_name(raw_name, lang)

        # Count parameters
        param_match = re.search(r'\(([^)]*)\)', header)
        params = param_match.group(1) if param_match else ''
        param_count = len([p for p in params.split(',') if p.strip()]) if params.strip() else 0

        # Extract return type
        ret_match = re.search(r'define\s+(?:\S+\s+)*?(\S+)\s+@', header)
        ret_type = ret_match.group(1) if ret_match else 'void'

        # Normalize body
        body_lines = []
        for line in lines[1:]:
            stripped = line.strip()

            # Skip debug intrinsics
            if self.strip_debug:
                if self.DEBUG_LOC.match(stripped):
                    continue
                if self.LIFETIME.match(stripped):
                    continue
                if stripped.startswith('call void @llvm.'):
                    continue

            # Skip Fortran array descriptor ops
            if self.FORTRAN_DESC.search(stripped):
                continue

            # Skip Rust drop glue calls
            if self.RUST_DROP.search(stripped):
                continue

            # Strip metadata and attributes
            normalized = self.strip_metadata(stripped)
            if not normalized:
                continue

            # Normalize types
            normalized = self.normalize_types_in_line(normalized)

            body_lines.append(normalized)

        # Anonymize registers
        body_lines = self.anonymize_registers(body_lines)

        # Extract basic blocks (labels)
        bbs = []
        current_bb = []
        for line in body_lines:
            if re.match(r'^%r\d+:', line) or re.match(r'^\w+:', line):
                if current_bb:
                    bbs.append(current_bb)
                current_bb = [line]
            else:
                current_bb.append(line)
        if current_bb:
            bbs.append(current_bb)

        func = NormalizedFunction(
            name=clean_name,
            original_name=raw_name,
            source_lang=lang,
            source_file=source_file,
            basic_blocks=['\n'.join(bb) for bb in bbs],
            instructions=body_lines,
            normalized_ir='\n'.join(body_lines),
            param_count=param_count,
            return_type=ret_type,
        )
        return func


def normalize_file(ir_path: str, source_path: str = "") -> List[NormalizedFunction]:
    """Convenience wrapper: normalize all functions in an IR file."""
    with open(ir_path, 'r', errors='replace') as f:
        ir_text = f.read()
    normalizer = IRNormalizer()
    return normalizer.extract_functions(ir_text, source_path or ir_path)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: ir_normalizer.py <file.ll> [source_file]")
        sys.exit(1)

    funcs = normalize_file(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "")
    for f in funcs:
        print(f"Function: {f.name} ({f.source_lang}) — {len(f.instructions)} instructions, "
              f"{len(f.basic_blocks)} basic blocks, {f.param_count} params")
