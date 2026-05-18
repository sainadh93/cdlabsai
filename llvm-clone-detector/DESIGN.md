# DESIGN.md — Cross-Language Clone Detector

## Problem Statement

Existing clone detectors operate on source text or ASTs and are therefore language-specific. A function implementing bubble sort in C and an identical algorithm in Rust share no lexical or syntactic tokens, yet are semantically equivalent. The goal is to identify such equivalences automatically.

---

## Approach: LLVM IR as Normalization Layer

LLVM IR is chosen as the common representation because:

1. **Language agnostic**: All LLVM frontend languages (C, C++, Rust, Fortran via Flang) compile to the same IR instruction set.
2. **Semantics-preserving**: IR at `-O1` retains most algorithmic structure without language-specific surface noise.
3. **Structured**: IR has explicit SSA form, typed instructions, and explicit CFG edges — amenable to graph analysis.
4. **Tooling**: Mature toolchain (`clang`, `rustc --emit=llvm-ir`, `flang`) with stable IR format.

### Pipeline Overview

```
Source Files (C / C++ / Rust / Fortran)
        │
        ▼ compile (clang / clang++ / rustc / flang)
LLVM IR (.ll text files)
        │
        ▼ IRNormalizer
Normalized IR Functions
  - demangled names
  - stripped metadata / debug info
  - anonymized SSA registers
  - normalized types (i32/i64 → iN)
        │
        ▼ FingerprintEngine
Function Fingerprints
  - opcode histogram
  - CFG metrics (BB count, CC, loops, back-edges)
  - WL graph hash
  - DFG metrics (def-use chains, phi count)
  - feature vector
        │
        ▼ SimilarityScorer (pairwise)
Clone Pairs with similarity scores
        │
        ▼ CLI Reporter
Text / JSON / CSV output
```

---

## Component Design

### 1. IR Normalization (`src/normalizer/ir_normalizer.py`)

The normalizer strips language-specific artifacts that would prevent cross-language matching:

| Artifact | Language | Action |
|----------|----------|--------|
| C++ mangled names (`_ZN...`) | C++ | Demangle to canonical `namespace::func` form |
| Rust name hashes (`::h1a2b3c4d...`) | Rust | Strip 16-hex hash suffix |
| Fortran module prefixes (`__mod_MOD_`) | Fortran | Strip to function name |
| LLVM debug metadata (`!dbg`, `!DISubprogram`) | All | Remove entirely |
| `llvm.lifetime.*` intrinsics | C/C++ | Remove |
| Rust drop glue (`@_ZN...4drop...`) | Rust | Skip drop calls |
| C++ vtable loads (`@_ZTV`) | C++ | Skip vtable refs |
| SSA register names (`%result`, `%i`) | All | Anonymize to `%r0`, `%r1`... |
| Platform integer widths (i32 vs i64 for indices) | All | Normalize to `iN` |
| `align` and `#attr` annotations | All | Strip |

**Design decision**: Normalize at `-O1` rather than `-O0` (preserves loop structure) or `-O3` (may inline/unroll, destroying clues).

### 2. CFG/DFG Fingerprinting (`src/fingerprint/fingerprint_engine.py`)

Each function is represented by a multi-dimensional fingerprint:

#### CFG Features
- **Basic block count**: Number of nodes in the CFG
- **Edge count**: Number of CFG edges
- **Cyclomatic complexity**: `E - N + 2` — captures branching complexity
- **Loop detection**: DFS back-edge count
- **Back-edge count**: Number of loops (nested loops = more back-edges)

#### Instruction Distribution
- **Opcode histogram**: Frequency of each opcode (add, sub, load, store, br, call, icmp, phi, etc.)
- **k-gram hash**: Rolling 3-gram hash of the opcode sequence — captures local instruction patterns

#### DFG Features
- **Def-use chain count**: Number of SSA assignments
- **PHI node count**: Reflects data join points (loop variables, if-else merges)
- **Load/store ratio**: Memory access pattern signature
- **Call count**: Degree of delegation to subroutines

#### Weisfeiler-Lehman Graph Hash
Iteratively hash each CFG node's label with its neighbors' labels (2 iterations). This produces a graph-structure fingerprint that is invariant to node ordering but sensitive to topology.

### 3. Similarity Scoring

A weighted combination of four metrics:

```
score = 0.35 × structural_cosine(v1, v2)
      + 0.35 × jaccard(opcode_bag1, opcode_bag2)
      + 0.20 × cfg_similarity(fp1, fp2)
      + 0.10 × param_similarity(fp1, fp2)
```

**Rationale for weights**:
- Structural vector and opcode distribution carry the most semantic signal.
- CFG topology is important but can vary across languages (e.g., Rust bounds-check branches).
- Parameter count is a weak but fast filter — mismatches reduce score.

---

## Alternatives Considered

### Alternative 1: AST-level Comparison (Rejected)

Comparing abstract syntax trees across languages requires per-language parsers and language-to-language AST mapping rules. This does not generalize to new languages without significant new engineering per language.

### Alternative 2: Text / Token Similarity (Rejected)

Token-level clone detectors (e.g., CCFinder, SourcererCC) are language-specific by design. Cross-language token similarity is near-zero for C vs Rust even for identical algorithms.

### Alternative 3: -O2 / -O3 IR (Considered)

Higher optimization levels canonicalize more code (e.g., loop invariant code motion, constant folding), which could improve TP rate. However, aggressive optimization can also unroll loops and inline functions, erasing structural clues. `-O1` is a better balance.

### Alternative 4: Bytecode Embedding / ML (Future Work)

Using a neural network to embed IR into a latent space (e.g., `code2vec`, `ir2vec`) could capture deeper semantic similarity. This was out of scope for this assignment but is a logical extension.

### Alternative 5: Program Dependence Graph (PDG) (Considered)

PDGs combine CFG and DFG and are theoretically more powerful. However, building precise PDGs from LLVM IR requires pointer alias analysis and is significantly more complex to implement. The chosen CFG + DFG feature combination approximates PDG-level information at lower implementation cost.

---

## Thresholds and Tuning

| Threshold | Behavior |
|-----------|----------|
| ≥ 0.90 | Near-exact structural clones (same algorithm, same language dialect) |
| 0.75 – 0.90 | Likely semantic clones (same algorithm, different language) |
| 0.60 – 0.75 | Plausible clones (same algorithmic family, e.g., search algorithms) |
| < 0.60 | Unlikely clones (different structure) |

Default threshold: **0.75** for production use; **0.60–0.65** for broad corpus sweeps.

---

## Limitations

1. **Inlined functions**: If the compiler inlines a function, it cannot be detected as a clone of a standalone function.
2. **Heavily optimized IR**: `-O3` can obscure algorithmic structure through unrolling and fusion.
3. **Template/generic expansion**: C++ template instantiations and Rust monomorphizations may produce multiple copies with suffixed names.
4. **Fortran compiler**: Requires `flang` (LLVM Fortran frontend); GNU Fortran (`gfortran`) does not emit LLVM IR natively.
5. **Scalability**: O(n²) pairwise comparison. For large corpora (>10k functions), approximate nearest-neighbor indexing (e.g., LSH on feature vectors) is needed.
