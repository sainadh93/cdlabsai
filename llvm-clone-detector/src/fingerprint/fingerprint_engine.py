#!/usr/bin/env python3
"""
Fingerprint Engine: Extracts CFG/DFG structural features from normalized IR
and computes pairwise similarity scores using multiple metrics.
"""

import re
import math
import hashlib
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from typing import List, Dict, Tuple, Set, Optional
from itertools import combinations

# Import normalizer types
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from normalizer.ir_normalizer import NormalizedFunction


@dataclass
class CFGNode:
    label: str
    instructions: List[str]
    successors: List[str] = field(default_factory=list)
    predecessors: List[str] = field(default_factory=list)
    instruction_types: List[str] = field(default_factory=list)


@dataclass
class FunctionFingerprint:
    func_name: str
    source_file: str
    source_lang: str

    # CFG features
    bb_count: int = 0
    edge_count: int = 0
    cyclomatic_complexity: int = 0
    max_bb_depth: int = 0
    has_loop: bool = False
    back_edge_count: int = 0

    # Instruction distribution (opcode histogram)
    opcode_histogram: Dict[str, int] = field(default_factory=dict)
    opcode_sequence_hash: str = ""  # k-gram hash of opcode sequence

    # DFG features
    def_use_chains: int = 0
    phi_count: int = 0
    call_count: int = 0
    branch_count: int = 0
    load_store_ratio: float = 0.0

    # Structural fingerprint (Weisfeiler-Lehman graph hash)
    wl_hash: str = ""

    # Raw instruction bag-of-words
    instruction_bag: Dict[str, int] = field(default_factory=dict)

    # Parameter count (structural match)
    param_count: int = 0
    return_type: str = "void"

    def to_vector(self) -> List[float]:
        """Convert fingerprint to a numeric feature vector for similarity."""
        opcodes = ['add', 'sub', 'mul', 'div', 'load', 'store', 'br', 'call',
                   'ret', 'icmp', 'fcmp', 'phi', 'alloca', 'getelementptr',
                   'bitcast', 'zext', 'sext', 'trunc', 'select', 'xor', 'and', 'or',
                   'shl', 'lshr', 'ashr', 'fadd', 'fsub', 'fmul', 'fdiv']
        total = max(sum(self.opcode_histogram.values()), 1)
        opcode_vec = [self.opcode_histogram.get(op, 0) / total for op in opcodes]

        return [
            self.bb_count / max(self.bb_count, 1),
            min(self.cyclomatic_complexity / 20.0, 1.0),
            min(self.call_count / 10.0, 1.0),
            1.0 if self.has_loop else 0.0,
            min(self.phi_count / 5.0, 1.0),
            min(self.param_count / 10.0, 1.0),
            self.load_store_ratio,
            min(self.def_use_chains / 50.0, 1.0),
        ] + opcode_vec


class CFGBuilder:
    """Build Control Flow Graph from normalized IR basic blocks."""

    BRANCH_OPS = {'br', 'switch', 'indirectbr', 'ret', 'unreachable', 'invoke', 'callbr'}
    CALL_OPS = {'call', 'invoke', 'tail', 'musttail', 'notail'}

    def build(self, func: NormalizedFunction) -> Dict[str, CFGNode]:
        """Build CFG nodes from function basic blocks."""
        nodes: Dict[str, CFGNode] = {}

        for i, bb_text in enumerate(func.basic_blocks):
            lines = [l.strip() for l in bb_text.strip().split('\n') if l.strip()]
            label = f"bb{i}"

            # Extract label if present
            if lines and re.match(r'^[%\w]+:', lines[0]):
                label = lines[0].rstrip(':')
                lines = lines[1:]

            # Extract instruction types (opcodes)
            inst_types = []
            for line in lines:
                tokens = line.split()
                if tokens:
                    # Handle "ret", "br", direct opcodes
                    op = tokens[0].lstrip('%')
                    # Handle "%r0 = add ..." → opcode is tokens[2]
                    if '=' in line and len(tokens) > 2:
                        eq_idx = tokens.index('=') if '=' in tokens else -1
                        if eq_idx >= 0 and eq_idx + 1 < len(tokens):
                            op = tokens[eq_idx + 1]
                    inst_types.append(op.lower())

            nodes[label] = CFGNode(
                label=label,
                instructions=lines,
                instruction_types=inst_types,
            )

        # Build edges from branch instructions
        labels = list(nodes.keys())
        for i, (label, node) in enumerate(nodes.items()):
            for line in node.instructions:
                tokens = line.split()
                if not tokens:
                    continue
                op = tokens[0].lower()
                if 'br' in op or 'switch' in op:
                    # Extract target labels
                    targets = re.findall(r'label\s+(%[\w.]+|[\w.]+)', line)
                    for t in targets:
                        t = t.lstrip('%')
                        if t in nodes:
                            node.successors.append(t)
                            nodes[t].predecessors.append(label)
                elif op == 'ret' or op == 'unreachable':
                    pass  # Terminal node
                elif i + 1 < len(labels):
                    # Fall-through to next block
                    next_label = labels[i + 1]
                    if next_label not in node.successors:
                        node.successors.append(next_label)
                        nodes[next_label].predecessors.append(label)

        return nodes


class FingerprintEngine:
    """
    Extracts multi-dimensional fingerprints from normalized IR functions.
    Supports CFG-structural, opcode-histogram, and WL-graph-hash features.
    """

    def __init__(self, kgram_size: int = 3):
        self.kgram_size = kgram_size
        self.cfg_builder = CFGBuilder()

    def fingerprint(self, func: NormalizedFunction) -> FunctionFingerprint:
        """Compute full fingerprint for a normalized function."""
        fp = FunctionFingerprint(
            func_name=func.name,
            source_file=func.source_file,
            source_lang=func.source_lang,
            param_count=func.param_count,
            return_type=func.return_type,
        )

        # Build CFG
        cfg = self.cfg_builder.build(func)

        # CFG metrics
        fp.bb_count = len(cfg)
        fp.edge_count = sum(len(n.successors) for n in cfg.values())
        fp.cyclomatic_complexity = max(fp.edge_count - fp.bb_count + 2, 1)
        fp.has_loop = self._detect_loops(cfg)
        fp.back_edge_count = self._count_back_edges(cfg)

        # Instruction analysis
        all_ops = []
        for node in cfg.values():
            all_ops.extend(node.instruction_types)

        fp.opcode_histogram = dict(Counter(all_ops))
        fp.call_count = fp.opcode_histogram.get('call', 0) + fp.opcode_histogram.get('invoke', 0)
        fp.branch_count = fp.opcode_histogram.get('br', 0) + fp.opcode_histogram.get('switch', 0)
        fp.phi_count = fp.opcode_histogram.get('phi', 0)

        loads = fp.opcode_histogram.get('load', 0)
        stores = fp.opcode_histogram.get('store', 0)
        fp.load_store_ratio = loads / max(loads + stores, 1)

        # Instruction bag
        fp.instruction_bag = fp.opcode_histogram.copy()

        # k-gram hash of opcode sequence
        fp.opcode_sequence_hash = self._kgram_hash(all_ops)

        # DFG: count def-use chains (approximate by counting SSA assignments)
        fp.def_use_chains = sum(1 for inst in func.instructions if '=' in inst)

        # WL hash for graph structure
        fp.wl_hash = self._wl_graph_hash(cfg)

        return fp

    def _detect_loops(self, cfg: Dict[str, CFGNode]) -> bool:
        """Detect loops via DFS back-edge detection."""
        visited = set()
        stack = set()

        def dfs(node: str) -> bool:
            visited.add(node)
            stack.add(node)
            for succ in cfg.get(node, CFGNode(label=node, instructions=[])).successors:
                if succ not in visited:
                    if dfs(succ):
                        return True
                elif succ in stack:
                    return True
            stack.discard(node)
            return False

        for node in cfg:
            if node not in visited:
                if dfs(node):
                    return True
        return False

    def _count_back_edges(self, cfg: Dict[str, CFGNode]) -> int:
        """Count back edges (loop indicators) via DFS."""
        visited = set()
        stack = set()
        count = [0]

        def dfs(node: str):
            visited.add(node)
            stack.add(node)
            for succ in cfg.get(node, CFGNode(label=node, instructions=[])).successors:
                if succ not in visited:
                    dfs(succ)
                elif succ in stack:
                    count[0] += 1
            stack.discard(node)

        for node in cfg:
            if node not in visited:
                dfs(node)
        return count[0]

    def _kgram_hash(self, ops: List[str]) -> str:
        """Compute rolling k-gram hash of opcode sequence."""
        if len(ops) < self.kgram_size:
            return hashlib.md5('|'.join(ops).encode()).hexdigest()[:16]
        kgrams = Counter()
        for i in range(len(ops) - self.kgram_size + 1):
            gram = ','.join(ops[i:i + self.kgram_size])
            kgrams[gram] += 1
        sig = '|'.join(f'{k}:{v}' for k, v in sorted(kgrams.most_common(10)))
        return hashlib.md5(sig.encode()).hexdigest()[:16]

    def _wl_graph_hash(self, cfg: Dict[str, CFGNode], iterations: int = 2) -> str:
        """
        Weisfeiler-Lehman graph hash: iteratively hash node labels
        with neighbor labels for structural fingerprinting.
        """
        labels = {n: hashlib.md5(','.join(node.instruction_types).encode()).hexdigest()[:8]
                  for n, node in cfg.items()}

        for _ in range(iterations):
            new_labels = {}
            for n, node in cfg.items():
                neighbor_labels = sorted(labels.get(s, '0') for s in node.successors)
                combined = labels[n] + '|' + ','.join(neighbor_labels)
                new_labels[n] = hashlib.md5(combined.encode()).hexdigest()[:8]
            labels = new_labels

        final = hashlib.md5(''.join(sorted(labels.values())).encode()).hexdigest()[:16]
        return final


class SimilarityScorer:
    """
    Computes pairwise similarity between function fingerprints.
    Combines multiple metrics with configurable weights.
    """

    def __init__(self,
                 weight_structural: float = 0.35,
                 weight_opcode: float = 0.35,
                 weight_cfg: float = 0.20,
                 weight_params: float = 0.10):
        self.w_struct = weight_structural
        self.w_opcode = weight_opcode
        self.w_cfg = weight_cfg
        self.w_params = weight_params

    def cosine_similarity(self, v1: List[float], v2: List[float]) -> float:
        """Cosine similarity between two vectors."""
        if not v1 or not v2:
            return 0.0
        dot = sum(a * b for a, b in zip(v1, v2))
        mag1 = math.sqrt(sum(a * a for a in v1))
        mag2 = math.sqrt(sum(b * b for b in v2))
        if mag1 == 0 or mag2 == 0:
            return 0.0
        return dot / (mag1 * mag2)

    def jaccard_similarity(self, bag1: Dict[str, int], bag2: Dict[str, int]) -> float:
        """Jaccard similarity on opcode bags."""
        all_keys = set(bag1.keys()) | set(bag2.keys())
        if not all_keys:
            return 1.0
        intersection = sum(min(bag1.get(k, 0), bag2.get(k, 0)) for k in all_keys)
        union = sum(max(bag1.get(k, 0), bag2.get(k, 0)) for k in all_keys)
        return intersection / union if union > 0 else 0.0

    def cfg_similarity(self, fp1: FunctionFingerprint, fp2: FunctionFingerprint) -> float:
        """Structural CFG similarity based on graph metrics."""
        if fp1.bb_count == 0 and fp2.bb_count == 0:
            return 1.0

        def ratio(a, b):
            return min(a, b) / max(a, b) if max(a, b) > 0 else 1.0

        bb_sim = ratio(fp1.bb_count, fp2.bb_count)
        cc_sim = ratio(fp1.cyclomatic_complexity, fp2.cyclomatic_complexity)
        loop_sim = 1.0 if fp1.has_loop == fp2.has_loop else 0.3
        phi_sim = ratio(fp1.phi_count + 1, fp2.phi_count + 1)
        edge_sim = ratio(fp1.edge_count + 1, fp2.edge_count + 1)

        # WL hash exact match bonus
        wl_bonus = 0.3 if fp1.wl_hash == fp2.wl_hash else 0.0

        return min((bb_sim * 0.25 + cc_sim * 0.25 + loop_sim * 0.20 +
                    phi_sim * 0.15 + edge_sim * 0.15 + wl_bonus), 1.0)

    def param_similarity(self, fp1: FunctionFingerprint, fp2: FunctionFingerprint) -> float:
        """Parameter count similarity."""
        if fp1.param_count == fp2.param_count:
            return 1.0
        diff = abs(fp1.param_count - fp2.param_count)
        return max(0.0, 1.0 - diff * 0.2)

    def score(self, fp1: FunctionFingerprint, fp2: FunctionFingerprint) -> Tuple[float, Dict]:
        """
        Compute overall similarity score [0, 1] and component breakdown.
        Returns (score, details_dict).
        """
        # Structural vector similarity
        v1, v2 = fp1.to_vector(), fp2.to_vector()
        struct_sim = self.cosine_similarity(v1, v2)

        # Opcode distribution similarity
        opcode_sim = self.jaccard_similarity(fp1.opcode_histogram, fp2.opcode_histogram)

        # CFG structural similarity
        cfg_sim = self.cfg_similarity(fp1, fp2)

        # Parameter count similarity
        param_sim = self.param_similarity(fp1, fp2)

        # Weighted combination
        total = (self.w_struct * struct_sim +
                 self.w_opcode * opcode_sim +
                 self.w_cfg * cfg_sim +
                 self.w_params * param_sim)

        details = {
            'structural': round(struct_sim, 4),
            'opcode': round(opcode_sim, 4),
            'cfg': round(cfg_sim, 4),
            'params': round(param_sim, 4),
            'wl_hash_match': fp1.wl_hash == fp2.wl_hash,
        }
        return round(total, 4), details


def fingerprint_functions(functions: List[NormalizedFunction]) -> List[FunctionFingerprint]:
    """Fingerprint a list of normalized functions."""
    engine = FingerprintEngine()
    return [engine.fingerprint(f) for f in functions]


def find_clone_pairs(fingerprints: List[FunctionFingerprint],
                     threshold: float = 0.75,
                     cross_language_only: bool = False) -> List[Tuple[FunctionFingerprint, FunctionFingerprint, float, Dict]]:
    """
    Find all pairs of functions above the similarity threshold.
    Returns list of (fp1, fp2, score, details).
    """
    scorer = SimilarityScorer()
    clone_pairs = []

    for fp1, fp2 in combinations(fingerprints, 2):
        if cross_language_only and fp1.source_lang == fp2.source_lang:
            continue
        # Quick filter: if BB counts differ by >3x, skip
        if fp1.bb_count > 0 and fp2.bb_count > 0:
            ratio = max(fp1.bb_count, fp2.bb_count) / min(fp1.bb_count, fp2.bb_count)
            if ratio > 4.0:
                continue
        score, details = scorer.score(fp1, fp2)
        if score >= threshold:
            clone_pairs.append((fp1, fp2, score, details))

    # Sort by score descending
    clone_pairs.sort(key=lambda x: x[2], reverse=True)
    return clone_pairs


if __name__ == '__main__':
    print("Fingerprint engine — import and use via clone_detector.py")
