#!/usr/bin/env bash
# ============================================================
# test_results.sh — Quick test of result reporting
# ============================================================
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
TC_DIR="$PROJECT_ROOT/testcases"
VENV="$PROJECT_ROOT/.venv/bin/activate"

[ -f "$VENV" ] && source "$VENV" 2>/dev/null || true

export PYTHONPATH="$SRC_DIR"
PYTHON="python3"
DETECTOR="$SRC_DIR/cli/clone_detector.py"

sep() { echo ""; echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; }

# Helper function to run detection and show result
run_and_report() {
    local test_name="$1"
    shift
    
    # Run detector and capture output
    output=$($PYTHON "$DETECTOR" detect "$@" 2>&1)
    
    # Print the key part of output
    echo "$output" | grep -A 2 "Clone Detection Results"
    
    # Check for clone pairs in output
    if echo "$output" | grep -q "Found [1-9][0-9]* clone pair"; then
        found=$(echo "$output" | grep "Found [1-9][0-9]* clone pair" | sed 's/.*Found \([0-9]*\) clone pair.*/\1/')
        echo ""
        echo "  ✓ RESULT: Clones Found ($found pair$([ "$found" -eq 1 ] && echo '' || echo 's'))"
        echo ""
    else
        echo ""
        echo "  ✗ RESULT: No Clones Found"
        echo ""
    fi
}

clear
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   TEST RESULT REPORTING — QUICK DEMO                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# TEST 1: Should find clones
sep
echo "  TEST 1: Bubble Sort (C vs C++ vs Rust)"
echo "  Expected: Clones Found ✓"
sep
run_and_report "Bubble Sort" \
    --inputs \
        "$TC_DIR/c/bubble_sort.ll" \
        "$TC_DIR/cpp/bubble_sort.ll" \
        "$TC_DIR/rust/bubble_sort.ll" \
    --threshold 0.88 \
    --min-bb 1 \
    --cross-lang \
    --output text

# TEST 2: Should find clones
sep
echo "  TEST 2: GCD (C vs Rust)"
echo "  Expected: Clones Found ✓"
sep
run_and_report "GCD" \
    --inputs \
        "$TC_DIR/c/functions.ll" \
        "$TC_DIR/rust/functions.ll" \
    --threshold 0.88 \
    --min-bb 1 \
    --cross-lang \
    --output text

# TEST 3: Single file (no pairs)
sep
echo "  TEST 3: Single IR File"
echo "  Expected: No Clones Found (single file, no pairs possible)"
sep
run_and_report "Single File" \
    --inputs \
        "$TC_DIR/c/factorial.c" \
    --threshold 0.88 \
    --min-bb 2 \
    --output text

sep
echo "  TEST COMPLETE"
sep
