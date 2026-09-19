#!/usr/bin/env python3
"""Build the first OpenGrid drawing-style test.

This is deliberately only a drawing-language check.  It does not yet attempt
to reproduce the full pinned OpenGrid geometry, dimensions, sections, detail
callouts or an engineering-sheet layout.

The canonical artifact is ordinary SVG authored with drawsvg.  Inkscape is
used only to render the PNG review image.
"""

from __future__ import annotations

from pathlib import Path
import subprocess

import drawsvg as draw


ROOT = Path(__file__).resolve().parents[2]
OUTPUT_ROOT = ROOT / "bld" / "drawing"
STEM = "00-opengrid-outline-test"

W = 180.0
H = 180.0
LINE = 1.2


def _run(args: list[str]) -> None:
    subprocess.run(args, cwd=ROOT, check=True)


def _polyline(points: list[tuple[float, float]], *, width: float = LINE) -> draw.Lines:
    flat: list[float] = []
    for x, y in points:
        flat.extend([x, y])
    return draw.Lines(
        *flat,
        close=True,
        fill="none",
        stroke="black",
        stroke_width=width,
        stroke_linejoin="miter",
    )


def _compose(svg: Path) -> None:
    sheet = draw.Drawing(W, H, origin=(0, 0))
    sheet.set_render_size(w="180mm", h="180mm")
    sheet.append(draw.Rectangle(0, 0, W, H, fill="white"))

    # Square outside boundary: all four outer corners are deliberately straight.
    sheet.append(
        draw.Rectangle(
            18,
            18,
            144,
            144,
            fill="none",
            stroke="black",
            stroke_width=LINE,
        )
    )

    # Simple OpenGrid-like inside frame.  The inner opening keeps the clipped
    # corners from the reference image, but no section marks, detail bubbles,
    # dimensions or labels are drawn yet.
    outer_inner = [
        (45, 34),
        (135, 34),
        (146, 45),
        (146, 135),
        (135, 146),
        (45, 146),
        (34, 135),
        (34, 45),
    ]
    inner_inner = [
        (49, 39),
        (131, 39),
        (141, 49),
        (141, 131),
        (131, 141),
        (49, 141),
        (39, 131),
        (39, 49),
    ]

    sheet.append(_polyline(outer_inner))
    sheet.append(_polyline(inner_inner))

    svg.parent.mkdir(parents=True, exist_ok=True)
    sheet.save_svg(str(svg))


def main() -> None:
    svg = OUTPUT_ROOT / f"{STEM}.svg"
    png = OUTPUT_ROOT / f"{STEM}.png"

    _compose(svg)

    _run(
        [
            "inkscape",
            str(svg),
            "--export-area-page",
            "--export-type=png",
            "--export-dpi=160",
            f"--export-filename={png}",
        ]
    )

    for output in (svg, png):
        if not output.is_file() or output.stat().st_size == 0:
            raise RuntimeError(f"missing drawing output: {output}")

    print(f"drawing: {svg.relative_to(ROOT)}")
    print(f"drawing: {png.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
