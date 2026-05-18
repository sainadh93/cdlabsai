# Cross-Language Code Clone Detector via LLVM IR

> **Assignment 23** — Detects semantically equivalent functions across C, C++, Rust, and Fortran by normalizing source code to LLVM IR and comparing control-flow and data-flow graph fingerprints.

---

## What It Does

Source-level clone detectors are language-specific and cannot find semantically equivalent code written in different languages. This tool uses LLVM IR as a language-agnostic representation:

1. **Compiles** C / C++ / Rust / Fortran sources to LLVM IR
2. **Normalizes** IR by stripping language-specific artifacts (C++ mangling, Rust drop glue, Fortran array descriptors)
3. **Fingerprints** each function using CFG structure, opcode histograms, Weisfeiler-Lehman graph hashes, and DFG metrics
4. **Scores** every function pair with a weighted similarity metric [0, 1]
5. **Reports** clone pairs above a configurable threshold with full source mappings

### Supported Languages
| Language | Compiler | Status |
|----------|----------|--------|
| C        | `clang`  | ✅ Full support |
| C++      | `clang++`| ✅ Full support |
| Rust     | `rustc`  | ✅ Full support |
| Fortran  | `flang`  | ✅ Pre-compiled IR included |
| Pre-compiled IR | — | ✅ Always works |

---

## Quick Start

### Prerequisites

```bash
# Minimum (always works — uses pre-compiled .ll IR files):
python3 --version   # Python 3.8+

# Optional (enables live compilation from source):
sudo apt-get install -y clang llvm   # Ubuntu/Debian
brew install llvm                    # macOS
rustup install stable                # Rust
```

### Build

```bash
./build.sh
```

This sets up the Python virtual environment, checks for LLVM tools, compiles test cases (if compilers are available), and runs a smoke test.

### Run

```bash
# Full demo — all 5 test cases + evaluation
./run.sh

# Detection only on precompiled IR
./run.sh detect

# Evaluation against labeled corpus
./run.sh evaluate

# Compare two specific IR files
./run.sh single testcases/c/bubble_sort.ll testcases/rust/bubble_sort.ll 0.5
```

---

## CLI Reference

```bash
# Detect clones in pre-compiled IR files
PYTHONPATH=src python3 src/cli/clone_detector.py detect \
    --inputs file1.ll file2.ll file3.ll \
    --threshold 0.75 \
    --output text|json|csv \
    --cross-lang \
    --min-bb 2 \
    --save results/out.json

# Compile sources and detect
PYTHONPATH=src python3 src/cli/clone_detector.py compile-and-detect \
    --sources ./my_project/ \
    --langs c,cpp,rust \
    --threshold 0.75

# Evaluate against labeled corpus
PYTHONPATH=src python3 src/cli/clone_detector.py evaluate \
    --corpus testcases/ \
    --threshold 0.65
```

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `--threshold` | 0.75 | Minimum similarity score to report |
| `--output` | text | Output format: `text`, `json`, `csv` |
| `--cross-lang` | false | Only report cross-language pairs |
| `--min-bb` | 2 | Minimum basic blocks per function |
| `--verbose` | false | Print per-function fingerprint details |
| `--save FILE` | none | Save results to file |

---

## Project Structure

```
llvm-clone-detector/
├── build.sh                    # Symlink → scripts/build.sh
├── run.sh                      # Symlink → scripts/run.sh
├── scripts/
│   ├── build.sh                # Setup, compile testcases, smoke test
│   └── run.sh                  # Demo runner (all modes)
├── src/
│   ├── normalizer/
│   │   └── ir_normalizer.py    # IR normalization pipeline
│   ├── fingerprint/
│   │   └── fingerprint_engine.py  # CFG/DFG fingerprinting + similarity
│   └── cli/
│       └── clone_detector.py   # Main CLI entrypoint
├── testcases/
│   ├── c/          # C sources + pre-compiled .ll
│   ├── cpp/        # C++ sources + pre-compiled .ll
│   ├── rust/       # Rust sources + pre-compiled .ll
│   ├── fortran/    # Fortran sources
│   └── expected/   # Known clone pairs for evaluation
├── results/        # Output directory
├── README.md
├── DESIGN.md
├── IMPLEMENTATION.md
└── EVALUATION.md
```

---

## Example Output

```
╔══════════════════════════════════════════════════════════════╗
║    Cross-Language Code Clone Detector via LLVM IR            ║
╚══════════════════════════════════════════════════════════════╝

  ┌─ Clone Pair #1 [CROSS-LANGUAGE]
  │  Score:  0.9889  (c↔rust)
  │  Func A: linear_search    testcases/c/functions.ll
  │  Func B: search::linear_search  testcases/rust/functions.ll
  │  Metrics:
  │    Structural: 0.9996  Opcode: 0.9688
  │    CFG:        1.0000  Params: 1.0000
  │  Stats A: 3 blocks, CC=1, no-loop
  │  Stats B: 3 blocks, CC=1, no-loop
  └────────────────────────────────────────────────────────────
```

---

## Demo Screenshots

See `results/` after running `./run.sh`. Screenshots showing:
- Working case: bubble sort detected as clone across C/C++/Rust (score ~0.89)
- Failure case: linear search vs binary search correctly rejected (CFG differs)

---

## Test Cases

| # | Functions | Languages | Expected | Type |
|---|-----------|-----------|----------|------|
| TC1 | `bubble_sort` | C ↔ C++ ↔ Rust | HIGH (≥0.65) | Semantic clone |
| TC2 | `gcd` | C ↔ Rust | HIGH (≥0.75) | Near-miss clone |
| TC3 | `linear_search` | C ↔ Rust | HIGH (≥0.72) | Near-miss clone |
| TC4 | `factorial` | C iterative | ~1.00 | Exact baseline |
| TC5 | `linear_search` vs `binary_search` | C ↔ C | LOW (≤0.65) | **Negative case** |
