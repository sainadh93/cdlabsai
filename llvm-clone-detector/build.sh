./#!/usr/bin/env bash
# ============================================================
# build.sh — Cross-Language Clone Detector: Build & Setup
# ============================================================
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$PROJECT_ROOT/.venv"
LOG_FILE="$PROJECT_ROOT/build.log"

echo "============================================================"
echo "  Cross-Language Code Clone Detector — Build Script"
echo "============================================================"
echo "[$(date)] Build started" | tee "$LOG_FILE"

# ── 1. Python ────────────────────────────────────────────────
echo ""
echo "[1/5] Checking Python..."
if ! python3 --version &>/dev/null; then
    echo "  ERROR: python3 not found. Install Python 3.8+."
    exit 1
fi
PYVER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "  Python $PYVER found."

# ── 2. Virtual environment ───────────────────────────────────
echo ""
echo "[2/5] Setting up virtual environment at $VENV_DIR..."
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "  Created venv."
else
    echo "  Venv already exists, skipping."
fi

source "$VENV_DIR/bin/activate"
pip install --quiet --upgrade pip

# Install dependencies
echo "  Installing Python dependencies..."
pip install --quiet networkx tabulate colorama >> "$LOG_FILE" 2>&1
echo "  Dependencies installed."

# ── 3. Check LLVM/Clang ─────────────────────────────────────
echo ""
echo "[3/5] Checking LLVM toolchain..."
LLVM_FOUND=0
for tool in clang clang++ opt llvm-dis; do
    if command -v "$tool" &>/dev/null; then
        VER=$("$tool" --version 2>&1 | head -1)
        echo "  ✓ $tool: $VER"
        LLVM_FOUND=1
    else
        echo "  ✗ $tool not found (optional — mock IR mode will be used)"
    fi
done

if command -v rustc &>/dev/null; then
    echo "  ✓ rustc: $(rustc --version)"
else
    echo "  ✗ rustc not found (optional)"
fi

if command -v flang &>/dev/null; then
    echo "  ✓ flang: $(flang --version 2>&1 | head -1)"
else
    echo "  ✗ flang not found (optional — Fortran IR tests use pre-compiled .ll)"
fi

if [ "$LLVM_FOUND" -eq 0 ]; then
    echo ""
    echo "  NOTE: LLVM not found. The tool will use pre-compiled .ll IR files."
    echo "  To install LLVM: sudo apt-get install -y clang llvm  (Ubuntu/Debian)"
    echo "                   brew install llvm                   (macOS)"
fi

# ── 4. Compile test cases (if clang available) ───────────────
echo ""
echo "[4/5] Compiling test case sources to IR..."
IR_DIR="$PROJECT_ROOT/testcases"

compile_if_available() {
    local cmd="$1"; local src="$2"; local out="$3"
    if command -v "${cmd%% *}" &>/dev/null; then
        echo "  Compiling $src..."
        eval "$cmd -S -emit-llvm -O1 -o $out $src" 2>>"$LOG_FILE" && echo "  → $out" || echo "  WARN: failed (using pre-compiled .ll)"
    fi
}

compile_if_available "clang"   "$IR_DIR/c/bubble_sort.c"    "$IR_DIR/c/bubble_sort.ll"
compile_if_available "clang"   "$IR_DIR/c/factorial.c"      "$IR_DIR/c/factorial.ll"
compile_if_available "clang"   "$IR_DIR/c/search.c"         "$IR_DIR/c/search.ll"
compile_if_available "clang"   "$IR_DIR/c/gcd.c"            "$IR_DIR/c/gcd.ll"
compile_if_available "clang"   "$IR_DIR/c/matmul.c"         "$IR_DIR/c/matmul.ll"
compile_if_available "clang"   "$IR_DIR/c/similar_different.c" "$IR_DIR/c/similar_different.ll"
compile_if_available "clang++" "$IR_DIR/cpp/bubble_sort.cpp" "$IR_DIR/cpp/bubble_sort.ll"
compile_if_available "clang++" "$IR_DIR/cpp/matmul.cpp"     "$IR_DIR/cpp/matmul.ll"

if command -v rustc &>/dev/null; then
    echo "  Compiling Rust sources..."
    rustc --emit=llvm-ir -C opt-level=1 \
        "$IR_DIR/rust/bubble_sort.rs" -o "$IR_DIR/rust/bubble_sort_rc.ll" 2>>"$LOG_FILE" || \
        echo "  WARN: rustc failed (using pre-compiled .ll)"
fi

echo "  Done."

# ── 5. Smoke test ────────────────────────────────────────────
echo ""
echo "[5/5] Running smoke test..."
cd "$PROJECT_ROOT"

PYTHONPATH="$PROJECT_ROOT/src" python3 src/cli/clone_detector.py detect \
    --inputs testcases/c/bubble_sort.ll testcases/cpp/bubble_sort.ll \
    --threshold 0.5 \
    --min-bb 1 \
    --output text 2>>"$LOG_FILE" | head -20

echo ""
echo "============================================================"
echo "  BUILD COMPLETE"
echo "  Run:  ./run.sh"
echo "  Logs: $LOG_FILE"
echo "============================================================"
