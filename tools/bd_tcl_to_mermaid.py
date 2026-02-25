#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Set, Tuple


# Heuristics to decide whether a .tcl looks like a Vivado Block Design export.
BD_HINT_PATTERNS = [
    re.compile(r"\bcreate_bd_design\b"),
    re.compile(r"\bcreate_bd_cell\b"),
    re.compile(r"\bconnect_bd_intf_net\b"),
    re.compile(r"\bconnect_bd_net\b"),
    re.compile(r"\bassign_bd_address\b"),
    re.compile(r"\bcreate_bd_addr_seg\b"),
]

CREATE_CELL_RE = re.compile(
    r"""create_bd_cell\s+
        (?:-type\s+\S+\s+)?          # optional -type
        (?:-vlnv\s+(\S+)\s+)?        # optional -vlnv
        (\S+)                        # instance name
    """,
    re.VERBOSE,
)

# Capture each endpoint inside [get_bd_intf_pins <endpoint>]
GET_BD_INTF_PINS_RE = re.compile(r"get_bd_intf_pins\s+([^\]\s]+)")
# Capture each endpoint inside [get_bd_pins <endpoint>]
GET_BD_PINS_RE = re.compile(r"get_bd_pins\s+([^\]\s]+)")


@dataclass(frozen=True)
class Edge:
    src_cell: str
    dst_cell: str
    kind: str  # "intf" or "net"
    src_ep: str
    dst_ep: str


def looks_like_bd_tcl(text: str) -> bool:
    hits = sum(1 for pat in BD_HINT_PATTERNS if pat.search(text))
    # require strong signals that it is a BD export
    return ("create_bd_cell" in text) and (("connect_bd_intf_net" in text) or ("connect_bd_net" in text)) and hits >= 2


def sanitize_path_to_filename(p: Path) -> str:
    s = p.as_posix()
    s = re.sub(r"[^A-Za-z0-9._/-]+", "_", s)
    s = s.replace("/", "__")
    if not s.endswith(".mmd"):
        s += ".mmd"
    return s


def cell_from_endpoint(ep: str) -> str:
    # "cell/port" -> "cell"
    return ep.split("/", 1)[0] if "/" in ep else ep


def node_id_for_cell(cell: str) -> str:
    return "n_" + re.sub(r"[^A-Za-z0-9_]", "_", cell)


def parse_cells(text: str) -> Dict[str, Optional[str]]:
    cells: Dict[str, Optional[str]] = {}
    for m in CREATE_CELL_RE.finditer(text):
        vlnv = m.group(1)
        inst = m.group(2)
        cells[inst] = vlnv
    return cells


def _extract_command_blocks(text: str, cmd: str) -> List[str]:
    """
    Extracts blocks like:
      connect_bd_intf_net ... <newline continuation> ...
    by accumulating lines until a line does NOT end with '\' continuation.
    """
    lines = text.splitlines()
    blocks: List[str] = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if not line.startswith(cmd):
            i += 1
            continue

        buf = [line]
        i += 1

        # very common for Vivado Tcl: line continuation with '\'
        while buf[-1].endswith("\\") and i < len(lines):
            buf[-1] = buf[-1][:-1].rstrip()
            buf.append(lines[i].strip())
            i += 1

        blocks.append(" ".join(buf))
    return blocks


def parse_edges(text: str) -> List[Edge]:
    edges: Set[Edge] = set()

    # Interfaces (AXI, etc.)
    for blk in _extract_command_blocks(text, "connect_bd_intf_net"):
        eps = GET_BD_INTF_PINS_RE.findall(blk)
        # Usually it’s 2 endpoints, but sometimes more. Connect all pairs in order.
        for a, b in _pairwise(eps):
            ea = a
            eb = b
            ca = cell_from_endpoint(ea)
            cb = cell_from_endpoint(eb)
            if ca != cb:
                edges.add(Edge(ca, cb, "intf", ea, eb))

    # Nets (clk/reset/etc.)
    for blk in _extract_command_blocks(text, "connect_bd_net"):
        eps = GET_BD_PINS_RE.findall(blk)
        for a, b in _pairwise(eps):
            ea = a
            eb = b
            ca = cell_from_endpoint(ea)
            cb = cell_from_endpoint(eb)
            if ca != cb:
                edges.add(Edge(ca, cb, "net", ea, eb))

    return sorted(edges, key=lambda e: (e.kind, e.src_cell, e.dst_cell, e.src_ep, e.dst_ep))


def _pairwise(items: Sequence[str]) -> Iterable[Tuple[str, str]]:
    """
    Turn [A, B, C] into (A,B), (A,C) to better represent bus/net fanout.
    For typical 2-item connects: yields (A,B).
    """
    if len(items) < 2:
        return []
    first = items[0]
    return [(first, it) for it in items[1:]]


def mermaid_for_design(
    tcl_path: Path,
    cells: Dict[str, Optional[str]],
    edges: List[Edge],
) -> str:
    lines: List[str] = []
    lines.append("flowchart LR")
    lines.append(f"  %% Auto-generated from: {tcl_path.as_posix()}")
    lines.append("")

    # Collect cells that appear in edges even if not in create_bd_cell matches
    seen_cells: Set[str] = set(cells.keys())
    for e in edges:
        seen_cells.add(e.src_cell)
        seen_cells.add(e.dst_cell)

    # Declare nodes with optional VLNV in the label (helps interpret blocks)
    for inst in sorted(seen_cells):
        nid = node_id_for_cell(inst)
        vlnv = cells.get(inst)
        if vlnv:
            lines.append(f'  {nid}["{inst}\\n{vlnv}"]')
        else:
            lines.append(f'  {nid}["{inst}"]')

    lines.append("")

    # Draw edges; include endpoint labels for accuracy.
    for e in edges:
        na = node_id_for_cell(e.src_cell)
        nb = node_id_for_cell(e.dst_cell)
        kind_label = "AXI/intf" if e.kind == "intf" else "net"
        ep_label = f"{e.src_ep} -> {e.dst_ep}"
        # Mermaid label: keep it readable; escape quotes.
        ep_label = ep_label.replace('"', "'")
        lines.append(f'  {na} -->|{kind_label}: {ep_label}| {nb}')

    lines.append("")
    return "\n".join(lines)


def update_readme_index(readme_path: Path, generated_files_abs: List[Path], repo_root: Path) -> None:
    start = "<!-- BD_MERMAID_INDEX_START -->"
    end = "<!-- BD_MERMAID_INDEX_END -->"

    if not readme_path.exists():
        raise SystemExit(
            f"README not found at {readme_path}.\n"
            "Either create README.md with the markers or run with --readme pointing to an existing file."
        )

    content = readme_path.read_text(encoding="utf-8")

    if start not in content or end not in content:
        raise SystemExit(
            "README is missing required markers.\n"
            "Add these lines to README.md once:\n\n"
            f"{start}\n{end}\n"
        )

    rels = [p.relative_to(repo_root).as_posix() for p in sorted(generated_files_abs)]

    block_lines: List[str] = []
    block_lines.append(start)
    block_lines.append("")
    block_lines.append("## Vivado Block Designs (auto-generated)")
    block_lines.append("")
    if not rels:
        block_lines.append("_No Vivado BD Tcl files detected (no create_bd_cell/connect_bd_* found)._")
    else:
        block_lines.append("Generated Mermaid files:")
        block_lines.append("")
        for r in rels:
            block_lines.append(f"- `{r}`")
        block_lines.append("")
        block_lines.append("Preview (first diagram):")
        block_lines.append("")
        first_rel = rels[0]
        first_abs = repo_root / first_rel
        block_lines.append("```mermaid")
        block_lines.append(first_abs.read_text(encoding="utf-8").rstrip())
        block_lines.append("```")
    block_lines.append("")
    block_lines.append(end)

    pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.DOTALL)
    new_content = pattern.sub("\n".join(block_lines), content)
    readme_path.write_text(new_content, encoding="utf-8")


def find_tcl_files(repo_root: Path) -> Iterable[Path]:
    for p in repo_root.rglob("*.tcl"):
        if ".git" in p.parts:
            continue
        yield p


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo-root", default=".", help="Repository root")
    ap.add_argument("--out-dir", default="docs/bd", help="Output directory for .mmd files")
    ap.add_argument("--readme", default="README.md", help="README file to update")
    args = ap.parse_args()

    repo_root = Path(args.repo_root).resolve()
    out_dir = (repo_root / args.out_dir).resolve()
    readme_path = (repo_root / args.readme).resolve()

    out_dir.mkdir(parents=True, exist_ok=True)

    generated_abs: List[Path] = []

    for tcl in find_tcl_files(repo_root):
        text = tcl.read_text(encoding="utf-8", errors="ignore")
        if not looks_like_bd_tcl(text):
            continue

        cells = parse_cells(text)
        edges = parse_edges(text)

        mmd = mermaid_for_design(tcl.relative_to(repo_root), cells, edges)

        out_name = sanitize_path_to_filename(tcl.relative_to(repo_root))
        out_path = out_dir / out_name
        out_path.write_text(mmd, encoding="utf-8")
        generated_abs.append(out_path)

    update_readme_index(readme_path, generated_abs, repo_root)


if __name__ == "__main__":
    main()