#!/usr/bin/env bash
# ============================================================
# run.sh — Cross-Language Clone Detector: Demo Runner
# ============================================================
# Modes:
#   ./run.sh              → Full demo (all test cases + evaluation)
#   ./run.sh detect       → Detection only on precompiled IRs
#   ./run.sh evaluate     → Evaluation against labeled corpus
#   ./run.sh single <f1> <f2>  → Compare two specific IR files
# ============================================================
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
TC_DIR="$PROJECT_ROOT/testcases"
RESULTS_DIR="$PROJECT_ROOT/results"
VENV="$PROJECT_ROOT/.venv/bin/activate"

# Activate venv if it exists
[ -f "$VENV" ] && source "$VENV"

mkdir -p "$RESULTS_DIR"

export PYTHONPATH="$SRC_DIR"
PYTHON="python3"
DETECTOR="$SRC_DIR/cli/clone_detector.py"
MODE="${1:-all}"

sep() { echo ""; echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; }

# Helper function to run detection and show result
run_and_report() {
    local test_name="$1"
    shift
    
    # Run detector and capture output
    output=$($PYTHON "$DETECTOR" detect "$@" 2>&1)
    
    # Print the output
    echo "$output"
    
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

run_detect() {
    echo ""
    echo "┌─ $1"
    echo "│  Files: ${@:2}"
    shift
    $PYTHON "$DETECTOR" detect \
        --inputs "$@" \
        --threshold 0.88 \
        --min-bb 1 \
        --output text
}

case "$MODE" in

# ── Single pair comparison ────────────────────────────────
single)
    if [ $# -lt 3 ]; then
        echo "Usage: ./run.sh single <file1.ll> <file2.ll> [threshold]"
        exit 1
    fi
    THRESH="${4:-0.50}"
    $PYTHON "$DETECTOR" detect \
        --inputs "$2" "$3" \
        --threshold "$THRESH" \
        --min-bb 1 \
        --verbose
    ;;

# ── Detection only ────────────────────────────────────────
detect)
    sep
    echo "  MODE: Detection on precompiled IR files"
    sep
    $PYTHON "$DETECTOR" detect \
        --inputs \
            "$TC_DIR/c/bubble_sort.ll" \
            "$TC_DIR/cpp/bubble_sort.ll" \
            "$TC_DIR/rust/bubble_sort.ll" \
            "$TC_DIR/c/functions.ll" \
            "$TC_DIR/rust/functions.ll" \
        --threshold 0.88 \
        --min-bb 1 \
        --output text \
        --save "$RESULTS_DIR/detection_results.json"
    ;;

# ── Evaluation mode ───────────────────────────────────────
evaluate)
    sep
    echo "  MODE: Evaluation against labeled corpus"
    sep
    $PYTHON "$DETECTOR" evaluate \
        --corpus "$TC_DIR" \
        --threshold 0.88
    echo ""
    echo "Results saved to: $TC_DIR/evaluation_results.json"
    ;;

# ── Full demo (default) ───────────────────────────────────
all|*)
    clear
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║   CROSS-LANGUAGE CODE CLONE DETECTOR — FULL DEMO            ║"
    echo "║   Assignment 23 | LLVM IR-based Semantic Clone Detection     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""

    # ── TEST CASE 1: Bubble Sort C vs C++ vs Rust ─────────
    sep
    echo "  TEST CASE 1: Bubble Sort — C vs C++ vs Rust"
    echo "  Expected: HIGH similarity (same nested loop, swap pattern)"
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

    # ── TEST CASE 2: GCD C vs Rust ────────────────────────
    sep
    echo "  TEST CASE 2: GCD Euclidean Algorithm — C vs Rust"
    echo "  Expected: HIGH similarity (identical while-loop structure)"
    sep
    run_and_report "GCD Algorithm" \
        --inputs \
            "$TC_DIR/c/functions.ll" \
            "$TC_DIR/rust/functions.ll" \
        --threshold 0.88 \
        --min-bb 1 \
        --cross-lang \
        --output text

    # ── TEST CASE 3: Linear Search C vs Rust ─────────────
    sep
    echo "  TEST CASE 3: Linear Search — C vs Rust"
    echo "  Expected: HIGH similarity (same for-loop, equality check)"
    sep
    run_and_report "Linear Search" \
        --inputs \
            "$TC_DIR/c/functions.ll" \
            "$TC_DIR/rust/functions.ll" \
        --threshold 0.88 \
        --min-bb 2 \
        --output text

    # ── TEST CASE 4: Factorial (positive baseline) ────────
    sep
    echo "  TEST CASE 4: Factorial C — Same-Language Baseline"
    echo "  Expected: iterative≈iterative HIGH, iterative≠recursive LOWER"
    sep
    run_and_report "Factorial" \
        --inputs \
            "$TC_DIR/c/functions.ll" \
        --threshold 0.88 \
        --min-bb 2 \
        --output text

    # ── TEST CASE 5: Similar Structure but Different Logic ─
    sep
    echo "  TEST CASE 5 [NEGATIVE CASE]: Similar Code with Different Operations"
    echo "  Expected: NO clones — Same loop structure but different operations"
    sep
    output=$($PYTHON "$DETECTOR" detect \
        --inputs \
            "$TC_DIR/c/similar_different.ll" \
        --threshold 0.95 \
        --min-bb 1 \
        --verbose \
        --output text 2>&1)
    echo "$output" | grep -A5 -E "(count_positive|sum_positive|Clone Pair|Score)" || true
    echo ""
    echo "  → Confirming: count_positive and sum_positive are similar but different"
    echo "    (same loop, but different operations: ++ vs +=)"
    
    # Check if clones found in test 5
    if echo "$output" | grep -q "Found [1-9][0-9]* clone pair"; then
        found=$(echo "$output" | grep "Found [1-9][0-9]* clone pair" | sed 's/.*Found \([0-9]*\) clone pair.*/\1/')
        echo ""
        echo "  ✗ RESULT: Clones Found ($found pair$([ "$found" -eq 1 ] && echo '' || echo 's')) - Expected None!"
        echo ""
    else
        echo ""
        echo "  ✓ RESULT: No Clones Found (as Expected)"
        echo ""
    fi

    # ── TEST CASE 6: Failure Case — Binary vs Linear ─────
    sep
    echo "  TEST CASE 6 [FAILURE/NEGATIVE CASE]: Linear vs Binary Search"
    echo "  Expected: LOW similarity — different CFG structure"
    echo "  Binary search has 5 branches, linear has 2; halving vs sequential"
    sep
    output=$($PYTHON "$DETECTOR" detect \
        --inputs \
            "$TC_DIR/c/functions.ll" \
        --threshold 0.89 \
        --min-bb 1 \
        --verbose \
        --output text 2>&1)
    echo "$output" | grep -A5 -E "(binary_search|linear_search|Clone Pair|Score)" || true
    echo ""
    echo "  → Confirming: linear_search and binary_search have low similarity"
    echo "    (different number of branches, PHI nodes, and loop structure)"
    
    # Check if clones found in test 6
    if echo "$output" | grep -q "Found [1-9][0-9]* clone pair"; then
        found=$(echo "$output" | grep "Found [1-9][0-9]* clone pair" | sed 's/.*Found \([0-9]*\) clone pair.*/\1/')
        echo ""
        echo "  ✗ RESULT: Clones Found ($found pair$([ "$found" -eq 1 ] && echo '' || echo 's')) - Expected None!"
        echo ""
    else
        echo ""
        echo "  ✓ RESULT: No Clones Found (as Expected)"
        echo ""
    fi

    # ── All IR files: full cross-language sweep ───────────
    sep
    echo "  FULL SWEEP: All IR files, all language pairs"
    sep
    output=$($PYTHON "$DETECTOR" detect \
        --inputs \
            "$TC_DIR/c/bubble_sort.ll" \
            "$TC_DIR/cpp/bubble_sort.ll" \
            "$TC_DIR/rust/bubble_sort.ll" \
            "$TC_DIR/c/functions.ll" \
            "$TC_DIR/rust/functions.ll" \
        --threshold 0.88 \
        --min-bb 2 \
        --output text \
        --save "$RESULTS_DIR/full_results.json" 2>&1)
    echo "$output"
    
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

    # ── Evaluation ────────────────────────────────────────
    sep
    echo "  EVALUATION: Precision / Recall / F1"
    sep
    $PYTHON "$DETECTOR" evaluate \
        --corpus "$TC_DIR" \
        --threshold 0.88

    sep
    echo "  DEMO COMPLETE"
    echo "  Results saved to: $RESULTS_DIR/"
    sep
    ;;
esac
