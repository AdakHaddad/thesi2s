#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path
from typing import Iterable, Tuple, List, Optional


BD_HINT_PATTERNS = [
    re.compile(r"\bcreate_bd_design\b"),
    re.compile(r"\bcreate_bd_cell\b"),
    re.compile(r"\bconnect_bd_intf_net\b"),
    re.compile(r"\bconnect_bd_net\b"),
]

CREATE_CELL_RE = re.compile(
    r"""create_bd_cell\s+
        (?:-type\s+\S+\s+)?   # optional -type
        (?:-vlnv\s+(\S+)\s+)? # optional -vlnv
        (\S+)                 # instance name
    """,
    re.VERBOSE,
)

# Example:
# connect_bd_intf_net [get_bd_intf_pins a/S_AXI] [get_bd_intf_pins b/M00_AXI]
CONNECT_INTF_RE = re.compile(
    r"""connect_bd_intf_net\b.*?
        get_bd_intf_pins\s+(\S+)\]\s+\[
        get_bd_intf_pins\s+(\S+)\]
    """,
    re.VERBOSE,
)

# Example:
# connect_bd_net [get_bd_pins a/clk] [get_bd_pins b/clk]
CONNECT_NET_RE = re.compile(
    r"""connect_bd_net\b.*?
        get_bd_pins\s+(\S+)\]\s+\[
        get_bd_pins\s+(\S+)\]
    """,
    re.VERBOSE,
)


def looks_like_bd_tcl(text: str) -> bool:
    hits = sum(1 for pat in BD_HINT_PATTERNS if pat.search(text))
    return (
        hits >= 2
        and ("create_bd_cell" in text)
        and (("connect_bd_intf_net" in text) or ("connect_bd_net" in text))
    )


def sanitize_path_to_filename(p: Path) -> str:
    # Keep stable, filesystem-friendly names; include folders to avoid collisions.
    s = str(p.as_posix())
    s = re.sub(r"[^A-Za-z0-9._/-]+", "_", s)
    s = s.replace("/", "__")
    if not s.endswith(".mmd"):
        s += ".mmd"
    return s


def parse_cells_and_edges(text: str) -> Tuple[List[Tuple[str, Optional[str]]], List[Tuple[str, str, str]]]:
    """
    Returns:
      cells: [(inst_name, vlnv)]
      edges: [(a, b, kind)] where a/b are "cell/pin"
    """
    cells: List[Tuple[str, Optional[str]]] = []
    edges: List[Tuple[str, str, str]] = []

    for m in CREATE_CELL_RE.finditer(text):
        vlnv = m.group(1)
        inst = m.group(2)
        cells.append((inst, vlnv))

    for m in CONNECT_INTF_RE.finditer(text):
        edges.append((m.group(1), m.group(2), "intf"))

    for m in CONNECT_NET_RE.finditer(text):
        edges.append((m.group(1), m.group(2), "net"))

    return cells, edges


def node_id_for_cell(cell: str) -> str:
    # Mermaid node ids must be simple; map instance name to safe id.
    return "n_" + re.sub(r"[^A-Za-z0-9_]", "_", cell)


def cell_from_endpoint(ep: str) -> str:
    # "cell/pin" -> "cell"
    return ep.split("/", 1)[0] if "/" in ep else ep


def mermaid_for_design(tcl_path: Path, cells: List[Tuple[str, Optional[str]]], edges: List[Tuple[str, str, str]]) -> str:
    lines: List[str] = []
    lines.append("flowchart LR")
    lines.append(f"  %% Auto-generated from: {tcl_path.as_posix()}")

    # declare nodes
    seen_cells = {inst for inst, _ in cells}
    # also include cells seen in edges
    for a, b, _ in edges:
        seen_cells.add(cell_from_endpoint(a))
        seen_cells.add(cell_from_endpoint(b))

    # stable output ordering
    for inst in sorted(seen_cells):
        nid = node_id_for_cell(inst)
        lines.append(f'  {nid}["{inst}"]')

    # edges
    for a, b, kind in edges:
        ca = cell_from_endpoint(a)
        cb = cell_from_endpoint(b)
        na = node_id_for_cell(ca)
        nb = node_id_for_cell(cb)
        label = "AXI/intf" if kind == "intf" else "net"
        lines.append(f"  {na} -->|{label}| {nb}")

    lines.append("")
    return "\n".join(lines)


def update_readme_index(readme_path: Path, generated_files_abs: List[Path], repo_root: Path) -> None:
    start = "<!-- BD_MERMAID_INDEX_START -->"
    end = "<!-- BD_MERMAID_INDEX_END -->"

    if not readme_path.exists():
        raise SystemExit(f"README not found at {readme_path}")

    content = readme_path.read_text(encoding="utf-8")

    if start not in content or end not in content:
        raise SystemExit(
            "README is missing required markers.\n"
            "Add these lines to README.md once:\n\n"
            f"{start}\n{end}\n"
        )

    # Use repo-relative paths in README (NOT /home/runner/...).
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
        # Preserve newlines; avoid turning it into one long line.
        block_lines.append(first_abs.read_text(encoding="utf-8").rstrip())
        block_lines.append("```")
    block_lines.append("")
    block_lines.append(end)

    # Replace marker region
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

        cells, edges = parse_cells_and_edges(text)
        mmd = mermaid_for_design(tcl.relative_to(repo_root), cells, edges)

        out_name = sanitize_path_to_filename(tcl.relative_to(repo_root))
        out_path = out_dir / out_name
        out_path.write_text(mmd, encoding="utf-8")
        generated_abs.append(out_path)

    update_readme_index(readme_path, generated_abs, repo_root)


if __name__ == "__main__":
    main()