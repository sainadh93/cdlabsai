# IMPLEMENTATION.md — LLVM IR Details

## LLVM IR Primer

LLVM IR (Intermediate Representation) is a typed, SSA-form (Static Single Assignment) assembly-like language. Every variable is assigned exactly once; control flow is explicit.

### Key IR Constructs Used

```llvm
; Function definition
define dso_local i32 @gcd(i32 %a, i32 %b) #0 {

; Basic block (starts with label, ends with terminator)
entry:
  %a.addr = alloca i32, align 4      ; Stack allocation
  store i32 %a, i32* %a.addr, align 4  ; Store to memory

loop.cond:
  %bv = load i32, i32* %b, align 4   ; Load from memory
  %cmp = icmp ne i32 %bv, 0          ; Integer comparison
  br i1 %cmp, label %loop.body, label %loop.end  ; Conditional branch

loop.body:
  %rem = srem i32 %av, %bv2          ; Signed remainder
  br label %loop.cond                 ; Unconditional branch

loop.end:
  ret i32 %retval                     ; Return
}
```

### SSA Form

In SSA, every value is assigned exactly once. Merges from multiple CFG paths are represented by `phi` instructions:

```llvm
; phi: "if coming from %if.then, take %val_then; else take %val_else"
%result = phi i32 [ %val_then, %if.then ], [ %val_else, %if.else ]
```

PHI node count is a strong structural signal: high PHI count indicates many data merge points (typical of loops with accumulators).

---

## Compilation Pipeline

### C / C++ → IR

```bash
clang   -S -emit-llvm -O1 -o output.ll source.c
clang++ -S -emit-llvm -O1 -o output.ll source.cpp
```

`-S` produces text IR (not binary bitcode), `-emit-llvm` selects LLVM IR output, `-O1` applies basic optimizations (mem2reg promotes allocas to SSA registers, dead code elimination).

### Rust → IR

```bash
rustc --emit=llvm-ir -C opt-level=1 -o output.ll source.rs
```

Rust emits per-crate IR. The `opt-level=1` corresponds roughly to LLVM `-O1`. Rust name mangling uses a hash suffix (`::h1a2b3c4d5e6f7a8b`) that we strip during normalization.

### Fortran → IR

```bash
flang -S -emit-llvm -O1 -o output.ll source.f90
```

Requires LLVM `flang` (not GNU `gfortran`). Fortran produces global function names with module prefixes (`__factorial_MOD_factorial`) and array descriptor structs for assumed-shape arrays.

### Optimizing IR Further (optional)

```bash
# Run additional LLVM passes: mem2reg, instcombine, simplifycfg
opt -passes="mem2reg,instcombine,simplifycfg" -S -o optimized.ll input.ll
```

---

## Normalization Implementation Details

### `IRNormalizer.detect_language()`

Language detection uses file extension first, then falls back to pattern matching in IR text:

```python
LANG_PATTERNS = {
    'rust':    [r'@_ZN\w+', r'@rust_', r'core::', r'std::'],
    'cpp':     [r'@_Z[A-Z]', r'@_ZTV'],
    'fortran': [r'@__', r'_mp_', r'_\$'],
}
```

### `IRNormalizer.demangle_name()`

The normalizer applies structural demangling without invoking external tools:

| Input (mangled) | Output (normalized) |
|----------------|---------------------|
| `_ZN11bubble_sort11bubble_sort17h3a9d8f2e1c4b5d6eE` | `bubble_sort::bubble_sort` |
| `_ZN6search3gcd17ha1b2c3d4e5f6a7b8E` | `search::gcd` |
| `__factorial_MOD_factorial` | `factorial` |
| `_Z11bubble_sortRSt6vectorIiSaIiEE` | `bubble_sort` |

Full demangling can be added by calling `c++filt` or `rustfilt` subprocess for production use.

### `IRNormalizer.anonymize_registers()`

SSA register names differ between compilers. The C compiler might name a variable `%i.addr` while Rust calls it `%i`. Anonymization maps all names to sequential `%r0`, `%r1`, ... before comparison.

```python
def anonymize_registers(self, instructions):
    reg_map = {}
    counter = [0]
    def get_reg(name):
        if name not in reg_map:
            reg_map[name] = f'%r{counter[0]}'
            counter[0] += 1
        return reg_map[name]
    return [re.sub(r'%[\w.]+', lambda m: get_reg(m.group(0)), line)
            for line in instructions]
```

### Type Normalization

`i32` vs `i64` is the most common platform/language difference (Rust uses `usize` = `i64` on 64-bit; C `int` = `i32`). Both are replaced with `iN`:

```python
line = re.sub(r'\bi(32|64)\b', 'iN', line)
```

---

## Fingerprinting Implementation Details

### CFG Construction (`CFGBuilder`)

The CFG is built by scanning basic blocks for branch terminators:

1. Each basic block becomes a node, identified by its label.
2. `br i1 %cond, label %then, label %else` → two outgoing edges
3. `br label %target` → one outgoing edge (fall-through)
4. `ret` → terminal node (no outgoing edges)

Fall-through edges (basic block i → basic block i+1 when no explicit branch) are added for blocks without terminators (artifact of partial IR parsing).

### Weisfeiler-Lehman Graph Hash

The WL algorithm (1-dimensional variant):

```python
# Iteration 0: Hash each node by its instruction type sequence
labels = {n: md5(','.join(node.instruction_types)) for n, node in cfg.items()}

# Iteration k: Incorporate neighbor labels
for _ in range(2):
    new_labels = {}
    for n, node in cfg.items():
        neighbor_labels = sorted(labels[s] for s in node.successors)
        combined = labels[n] + '|' + ','.join(neighbor_labels)
        new_labels[n] = md5(combined)[:8]
    labels = new_labels

# Final: Sort node labels (order-invariant) and hash
final_hash = md5(''.join(sorted(labels.values())))
```

Two iterations are sufficient to distinguish most non-isomorphic small graphs (CFGs typically have 2–20 nodes).

### Opcode Histogram

```python
# Normalize: express as frequency distribution
total = sum(histogram.values())
normalized = {op: count/total for op, count in histogram.items()}
```

Key opcodes for clone detection:

| Opcode | Meaning | Clone signal |
|--------|---------|--------------|
| `br` | Branch | Branching frequency |
| `phi` | PHI merge | Loop/if complexity |
| `icmp` | Integer compare | Condition patterns |
| `load/store` | Memory | Memory access pattern |
| `call` | Function call | Delegation pattern |
| `getelementptr` | Pointer arithmetic | Array/struct access |
| `srem/urem` | Remainder | Modular arithmetic (GCD!) |

### Similarity Scoring

The `cosine_similarity` on the feature vector handles different scale functions naturally:

```python
def to_vector(fp) -> List[float]:
    opcodes = ['add', 'sub', 'mul', 'div', 'load', 'store', 'br', 'call',
               'ret', 'icmp', 'fcmp', 'phi', 'alloca', 'getelementptr', ...]
    total = max(sum(fp.opcode_histogram.values()), 1)
    opcode_vec = [fp.opcode_histogram.get(op, 0) / total for op in opcodes]
    return [
        # Structural features (0–1 normalized)
        fp.cyclomatic_complexity / 20.0,
        fp.call_count / 10.0,
        1.0 if fp.has_loop else 0.0,
        fp.phi_count / 5.0,
        fp.param_count / 10.0,
        fp.load_store_ratio,
        fp.def_use_chains / 50.0,
    ] + opcode_vec
```

---

## File Format Details

### Input: LLVM IR Text (`.ll`)

Standard LLVM IR textual format, as produced by `clang -S -emit-llvm`. The normalizer handles:
- UTF-8 encoding with `errors='replace'` fallback
- Both Windows (`\r\n`) and Unix (`\n`) line endings
- Incomplete IR files (partial function bodies)

### Output Formats

**Text** (default): Human-readable console output with box-drawing characters.

**JSON**: Structured output for downstream processing:
```json
{
  "clone_pairs": [{
    "score": 0.9889,
    "cross_language": true,
    "function_a": {"name": "linear_search", "lang": "c", "bb_count": 3},
    "function_b": {"name": "search::linear_search", "lang": "rust", "bb_count": 3},
    "metric_breakdown": {"structural": 0.9996, "opcode": 0.9688, "cfg": 1.0, "params": 1.0}
  }]
}
```

**CSV**: One row per clone pair, suitable for spreadsheet analysis and plotting.

---

## Mock IR Generation

When compilers are unavailable, `_generate_mock_ir()` parses source files heuristically and generates representative IR:

1. Extracts function signatures with regex
2. Detects loops (`for/while/do`), branches (`if`), arithmetic (`+/-/*`)  
3. Emits corresponding IR patterns (loop CFG, branch CFG, arithmetic instructions)

This allows the full pipeline to run in any environment without LLVM installation.
