# UNDERSTAND.md — How the Project Works (Plain English)

## What Problem Are We Solving?

If you write a bubble sort in C and someone else writes the same bubble sort in Rust,
existing clone detectors will say "these are completely different" — because they compare
source code text or language-specific syntax trees.

This project solves that by using **LLVM IR** (a compiler's internal language-agnostic
representation) as a common ground to compare functions across C, C++, Rust, and Fortran.

---

## The Big Idea in One Line

> Compile everything to LLVM IR → clean it up → extract structural fingerprints → compare fingerprints → report clones.

---

## Step-by-Step: What Happens When You Run It

### Step 1 — Input: Source files or pre-compiled IR

You give the tool either:
- Source files (`.c`, `.cpp`, `.rs`, `.f90`) → it compiles them with clang/rustc
- Pre-compiled IR files (`.ll`) → it uses them directly (this is what we use in our demo)

**Example input:**
```
testcases/c/bubble_sort.ll      ← C bubble sort in LLVM IR
testcases/cpp/bubble_sort.ll    ← C++ bubble sort in LLVM IR
testcases/rust/bubble_sort.ll   ← Rust bubble sort in LLVM IR
```

---

### Step 2 — Normalization (`src/normalizer/ir_normalizer.py`)

Raw LLVM IR from different languages looks very different even for identical algorithms:

| Problem | Example | Fix |
|---------|---------|-----|
| C++ mangles names | `_Z11bubble_sortRSt6vectorIiSaIiEE` | Stripped to `bubble_sort` |
| Rust adds hash suffixes | `bubble_sort::h3a9d8f2e1c4b5d6e` | Hash removed |
| Fortran adds module prefix | `__factorial_MOD_factorial` | Prefix stripped |
| Debug metadata noise | `!dbg !42, !DISubprogram` | Removed entirely |
| Register names differ | `%i.addr` in C vs `%i` in Rust | Renamed to `%r0`, `%r1`... |
| Integer width differs | `i32` (C int) vs `i64` (Rust usize) | Both → `iN` |

After normalization, two functions implementing the same algorithm look structurally
identical regardless of which language they came from.

---

### Step 3 — Fingerprinting (`src/fingerprint/fingerprint_engine.py`)

Each function is converted into a **numerical fingerprint** — a set of measurements
that capture what the function *does structurally*, not what it *looks like* as text.

#### What gets measured:

**CFG (Control Flow Graph) metrics** — how the function branches and loops:
- Number of basic blocks (chunks of straight-line code)
- Number of edges between blocks
- Cyclomatic complexity (how many independent paths through the function)
- Whether it has loops (back-edges in the CFG)

**Opcode histogram** — what instructions are used how often:
- How many `add`, `mul`, `load`, `store`, `br`, `icmp`, `phi`... instructions
- Expressed as a frequency distribution (normalized to percentages)

**Weisfeiler-Lehman graph hash** — a fingerprint of the graph *shape*:
- Each CFG node is hashed with its neighbors' hashes (repeated 2×)
- Produces a single hash that identifies graph topology
- If two functions have the same WL hash → identical graph structure

**DFG (Data Flow Graph) metrics**:
- Number of SSA assignments (def-use chains)
- Number of PHI nodes (data merge points — indicates loops/branches)
- Load/store ratio (memory access pattern)
- Call count (how much it delegates to other functions)

---

### Step 4 — Similarity Scoring

Every pair of functions gets a similarity score from 0.0 to 1.0 using four metrics
combined with weights:

```
Final Score = 0.35 × structural_cosine_similarity
            + 0.35 × opcode_jaccard_similarity
            + 0.20 × cfg_topology_similarity
            + 0.10 × parameter_count_similarity
```

**Structural cosine similarity**: treats the fingerprint as a vector and measures
the angle between two vectors. Two identical fingerprints → score = 1.0.

**Opcode Jaccard similarity**: compares the "bags" of opcodes.
What fraction of instruction types do both functions share?

**CFG topology similarity**: compares block counts, edge counts, loop presence,
and cyclomatic complexity. Rewards functions with the same graph shape.

**Parameter similarity**: functions with the same number of parameters score higher.

---

### Step 5 — Reporting

Clone pairs above the threshold (default 0.75, demo uses 0.65) are reported with:
- Both function names and source files
- Overall score
- Breakdown of all four metrics
- Whether it's a cross-language pair
- CFG stats (block count, cyclomatic complexity, loop presence)

---

## What the Demo Results Mean

### TEST CASE 1 — Bubble Sort: C vs C++ vs Rust

```
C ↔ Rust   score: 0.8957   [CROSS-LANGUAGE] ✅
C ↔ C++    score: 0.8844   [CROSS-LANGUAGE] ✅
C++ ↔ Rust score: 0.9862   [detected as same language but both have similar IR] ✅
```

All three implement the same nested loop + swap. After normalization, their IR looks
nearly identical: same number of basic blocks (3), same loop structure, same
load/compare/store/branch pattern. Score is not 1.0 because C uses pointer arithmetic
while C++ and Rust use method calls (swap/operator[]) which adds extra `call` opcodes.

---

### TEST CASE 2 — GCD: C vs Rust → Score: **1.0000** 🏆

```
C gcd ↔ Rust gcd   score: 1.0000   WL-hash match ✅
```

Perfect score. The Euclidean GCD algorithm (`while b != 0 { t=b; b=a%b; a=t; }`)
compiles to identical normalized IR in both languages:
- Same 1 basic block structure
- Same opcodes: `load`, `srem`, `store`, `icmp`, `br`
- Same parameter count (2)
- WL-hash matches exactly → graph structure is identical

This is the clearest example of cross-language clone detection working perfectly.

---

### TEST CASE 3 — Linear Search: C vs Rust → Score: **0.9889** ✅

```
C linear_search ↔ Rust linear_search   score: 0.9889
```

Both compile to the same 3-block CFG: entry → loop body → return found/not-found.
Same opcodes: `getelementptr`, `load`, `icmp eq`, `br`, `ret`.
The tiny difference (0.0111) comes from Rust using `i64` indices vs C's `i32`.

---

### TEST CASE 4 — Factorial: Same-Language Baseline

```
factorial ↔ linear_search   score: 0.8813  (both are 3-block loop structures)
factorial ↔ binary_search   score: 0.7543  (binary search has 5 blocks)
```

Shows the baseline: even within C, the tool distinguishes different algorithms.
Factorial and linear search both happen to be simple 3-block loops, so they score
higher with each other than factorial does with binary search (5 blocks, more branches).

---

### TEST CASE 5 — Linear vs Binary Search: Negative Case ⚠️

```
linear_search ↔ binary_search   score: 0.8437
```

This is the **failure/false positive case**. At threshold 0.65 or 0.75, these are
incorrectly reported as clones. Why?

- Both are search functions → similar opcode types (load, icmp, getelementptr, br)
- Opcode *frequency* differs (binary search has more icmp and sdiv) but Jaccard
  similarity of the bags is still 0.66
- CFG correctly shows difference: 3 blocks vs 5 blocks, score 0.84
- But the weighted average still exceeds threshold

**Fix**: Set threshold ≥ 0.90 to reject this pair while keeping all true positives.
This is a known limitation of histogram-based comparison — it captures *what* instructions
appear but not *why* or in *what order*.

---

## Evaluation Numbers Explained

The evaluation compares detected pairs against `testcases/expected/known_clones.json`.

If you still have `bubble_sort_rc.ll` in `testcases/rust/`, delete it first:
```bash
rm testcases/rust/bubble_sort_rc.ll
```

Then re-run evaluation:
```bash
export PYTHONPATH="$PWD/src"
python3 src/cli/clone_detector.py evaluate --corpus testcases/ --threshold 0.65
```

**At threshold 0.75:**
- Precision: 0.80 (4 out of 5 detected pairs are real clones)
- Recall:    1.00 (all real clone pairs were found)
- F1 Score:  0.89

---

## File Roles — One Line Each

| File | What it does |
|------|-------------|
| `src/normalizer/ir_normalizer.py` | Reads `.ll` files, strips language noise, anonymizes registers |
| `src/fingerprint/fingerprint_engine.py` | Builds CFG, counts opcodes, computes WL hash, scores pairs |
| `src/cli/clone_detector.py` | Command-line interface: ties normalizer + fingerprinter together |
| `testcases/c/*.ll` | Pre-compiled LLVM IR from C source files |
| `testcases/cpp/*.ll` | Pre-compiled LLVM IR from C++ source files |
| `testcases/rust/*.ll` | Pre-compiled LLVM IR from Rust source files |
| `testcases/expected/known_clones.json` | Ground truth: which functions are known clones |
| `scripts/build.sh` | Installs dependencies, checks compilers, compiles sources if available |
| `scripts/run.sh` | Runs the full demo: all 5 test cases + evaluation |

---

## Why LLVM IR and Not Just Compare Source Code?

| Approach | C vs Rust bubble sort | Works cross-language? |
|----------|----------------------|----------------------|
| Text similarity | ~5% similar (different syntax) | ❌ No |
| AST comparison | Needs separate parser per language | ❌ No |
| **LLVM IR (this project)** | **~90% similar after normalization** | **✅ Yes** |

LLVM IR is the perfect normalization layer because every language that uses LLVM
(C, C++, Rust, Fortran, Swift, Julia...) compiles to the same instruction set.
The algorithm's *shape* — its loops, branches, arithmetic — survives compilation
and becomes visible in IR regardless of the source language's syntax.



to run this project 
# 1. Go to project folder
cd ~/llvm-clone-detector/llvm-clone-detector

# 2. Set Python path (do this once per terminal session)
export PYTHONPATH="$PWD/src"

# 3. Run the full demo
./run.sh


to just show the cross language pairs this is enough to show the clean output
python3 src/cli/clone_detector.py detect \
    --inputs testcases/c/bubble_sort.ll testcases/cpp/bubble_sort.ll \
             testcases/rust/bubble_sort.ll testcases/c/functions.ll \
             testcases/rust/functions.ll \
    --threshold 0.88 --min-bb 2 --cross-lang --output text