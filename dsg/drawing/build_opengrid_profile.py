#!/usr/bin/env python3
"""Build the first composed OpenGrid Lite profile sheet.

OpenSCAD supplies the pinned/source-derived geometry views.  drawsvg owns the
sheet, dimensions and title block.  Inkscape is invoked only for publication
renders; the canonical artifact remains ordinary SVG.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path
import subprocess
import tempfile
import xml.etree.ElementTree as ET

import drawsvg as draw


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "dsg" / "drawing" / "opengrid_fixed_profile_sources.scad"
OUTPUT_ROOT = ROOT / "bld" / "drawing"
STEM = "00-opengrid-fixed-profile-a4"

A4_W = 297.0
A4_H = 210.0
MARGIN = 10.0

LINE = 0.35
THIN = 0.22
FONT = "DejaVu Sans"
PINNED_QUACKWORKS = "e0c1cb7ec78dd9e9a8476ed739bd3402074354f3"


@dataclass(frozen=True)
class ProfileMeta:
    capture_width: float
    lower_width: float
    top_width: float
    height: float
    lower_radial_offset: float
    top_radial_offset: float
    bands: tuple[float, float, float, float]


def _run(args: list[str]) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        args,
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(
            "command failed: "
            + " ".join(args)
            + "\n"
            + result.stdout
        )
    return result


def _source_svg(view: str, output: Path) -> str:
    result = _run(
        [
            "openscad",
            "-D",
            f'drawing_source_view="{view}"',
            "-o",
            str(output),
            str(SOURCE),
        ]
    )
    if not output.is_file() or output.stat().st_size == 0:
        raise RuntimeError(f"OpenSCAD did not create {output}")
    return result.stdout


def _metadata(log: str) -> ProfileMeta:
    match = re.search(r"DRAWING_META:([0-9.,+-]+)", log)
    if match is None:
        raise RuntimeError("OpenSCAD drawing metadata was not emitted")

    values = [float(item) for item in match.group(1).split(",")]
    if len(values) != 10:
        raise RuntimeError(f"unexpected drawing metadata: {values!r}")

    (
        capture_width,
        lower_width,
        top_width,
        height,
        lower_offset,
        top_offset,
        band_1,
        band_2,
        band_3,
        band_4,
    ) = values
    return ProfileMeta(
        capture_width=capture_width,
        lower_width=lower_width,
        top_width=top_width,
        height=height,
        lower_radial_offset=lower_offset,
        top_radial_offset=top_offset,
        bands=(band_1, band_2, band_3, band_4),
    )


def _text(
    sheet: draw.Drawing,
    value: str,
    size: float,
    x: float,
    y: float,
    *,
    center: bool = False,
    weight: str | None = None,
) -> None:
    kwargs: dict[str, object] = {
        "fill": "black",
        "font_family": FONT,
    }
    if weight is not None:
        kwargs["font_weight"] = weight
    sheet.append(
        draw.Text(
            value,
            size,
            x,
            y,
            center=center,
            **kwargs,
        )
    )


def _line(
    sheet: draw.Drawing,
    x1: float,
    y1: float,
    x2: float,
    y2: float,
    *,
    width: float = LINE,
    **kwargs: object,
) -> None:
    sheet.append(
        draw.Line(
            x1,
            y1,
            x2,
            y2,
            stroke="black",
            stroke_width=width,
            fill="none",
            **kwargs,
        )
    )


def _arrow_marker() -> draw.Marker:
    marker = draw.Marker(-0.1, -0.51, 0.9, 0.5, scale=2.3, orient="auto-start-reverse")
    marker.append(
        draw.Lines(
            -0.1,
            0.50,
            -0.1,
            -0.50,
            0.90,
            0.0,
            close=True,
            fill="black",
        )
    )
    return marker


def _dimension_h(
    sheet: draw.Drawing,
    arrow: draw.Marker,
    x1: float,
    x2: float,
    y: float,
    extension_y: float,
    label: str,
) -> None:
    _line(sheet, x1, extension_y, x1, y, width=THIN)
    _line(sheet, x2, extension_y, x2, y, width=THIN)
    _line(
        sheet,
        x1,
        y,
        x2,
        y,
        width=THIN,
        marker_start=arrow,
        marker_end=arrow,
    )
    _text(sheet, label, 3.0, (x1 + x2) / 2, y - 1.8, center=True)


def _dimension_v(
    sheet: draw.Drawing,
    arrow: draw.Marker,
    y1: float,
    y2: float,
    x: float,
    extension_x: float,
    label: str,
) -> None:
    _line(sheet, extension_x, y1, x, y1, width=THIN)
    _line(sheet, extension_x, y2, x, y2, width=THIN)
    _line(
        sheet,
        x,
        y1,
        x,
        y2,
        width=THIN,
        marker_start=arrow,
        marker_end=arrow,
    )
    cy = (y1 + y2) / 2
    sheet.append(
        draw.Text(
            label,
            3.0,
            x + 3.4,
            cy,
            center=True,
            fill="black",
            font_family=FONT,
            transform=f"rotate(-90 {x + 3.4} {cy})",
        )
    )


def _embedded_svg(
    sheet: draw.Drawing,
    path: Path,
    x: float,
    y: float,
    width: float,
    height: float,
) -> None:
    """Inline OpenSCAD SVG paths into the canonical sheet.

    ElementTree is used only as an interchange parser here; all authored
    drawing semantics remain drawsvg-owned. Inlining avoids renderer-specific
    handling of nested SVG data URIs and keeps line weights predictable.
    """

    root = ET.parse(path).getroot()
    viewbox = root.attrib.get("viewBox")
    if viewbox is None:
        raise RuntimeError(f"OpenSCAD SVG has no viewBox: {path}")

    min_x, min_y, source_w, source_h = [
        float(value) for value in viewbox.replace(",", " ").split()
    ]
    if source_w <= 0 or source_h <= 0:
        raise RuntimeError(f"invalid OpenSCAD SVG viewBox: {viewbox}")

    scale = min(width / source_w, height / source_h)
    tx = x + (width - source_w * scale) / 2 - min_x * scale
    ty = y + (height - source_h * scale) / 2 - min_y * scale

    group = draw.Group(transform=f"translate({tx} {ty}) scale({scale})")
    svg_ns = "{http://www.w3.org/2000/svg}"

    paths = root.findall(f".//{svg_ns}path")
    if not paths:
        raise RuntimeError(f"OpenSCAD SVG contains no paths: {path}")

    for source_path in paths:
        d = source_path.attrib.get("d")
        if not d:
            continue
        group.append(
            draw.Path(
                d=d,
                fill=source_path.attrib.get("fill", "none"),
                stroke=source_path.attrib.get("stroke", "black"),
                # Counteract the group scale so source geometry uses the same
                # physical line weight as the authored sheet.
                stroke_width=LINE / scale,
            )
        )

    sheet.append(group)


def _title_block(sheet: draw.Drawing) -> None:
    x = 174.0
    y = 174.0
    w = 113.0
    h = 26.0

    sheet.append(
        draw.Rectangle(
            x,
            y,
            w,
            h,
            fill="white",
            stroke="black",
            stroke_width=LINE,
        )
    )
    _line(sheet, x, y + 11, x + w, y + 11)
    _line(sheet, x + 72, y + 11, x + 72, y + h)
    _line(sheet, x + 91, y + 11, x + 91, y + h)

    _text(sheet, "OPENGRID LITE FIXED-SIDE PROFILE", 3.4, x + 4, y + 7.2, weight="bold")
    _text(sheet, "OG-LITE-PROFILE", 2.6, x + 4, y + 18.5)
    _text(sheet, "SCALE", 1.8, x + 75, y + 15.2)
    _text(sheet, "AS SHOWN", 2.4, x + 75, y + 21.8)
    _text(sheet, "UNITS", 1.8, x + 94, y + 15.2)
    _text(sheet, "mm", 2.4, x + 94, y + 21.8)


def _compose(
    orientation: Path,
    section: Path,
    detail: Path,
    meta: ProfileMeta,
    output: Path,
) -> None:
    sheet = draw.Drawing(A4_W, A4_H, origin=(0, 0))
    # Keep physical A4 dimensions while retaining a 0..297 × 0..210 mm viewBox.
    sheet.set_render_size(w="297mm", h="210mm")
    arrow = _arrow_marker()

    sheet.append(draw.Rectangle(0, 0, A4_W, A4_H, fill="white"))
    sheet.append(
        draw.Rectangle(
            MARGIN,
            MARGIN,
            A4_W - 2 * MARGIN,
            A4_H - 2 * MARGIN,
            fill="none",
            stroke="black",
            stroke_width=LINE,
        )
    )

    # View A: actual pinned receiver projected obliquely for orientation.
    _text(sheet, "VIEW A — ORIENTED RECEIVER", 3.6, 18, 20, weight="bold")
    _text(sheet, "actual pinned geometry • scale 2.0:1", 2.3, 18, 25)
    _embedded_svg(sheet, orientation, 18, 29, 84, 65)

    # Main information view: exact transverse profile from the pinned receiver.
    _text(sheet, "SECTION A-A — TRANSVERSE FIXED PROFILE", 3.6, 88, 78, weight="bold")
    _text(sheet, "source geometry • nominal dimensions • scale 4.2:1", 2.3, 88, 83)
    _embedded_svg(sheet, section, 92, 89, 126, 38)

    # This OpenSCAD SVG has viewBox -15 -3 30 6. The 126 mm-wide target
    # therefore maps source coordinates at exactly 4.2:1. Anchor nominal
    # dimensions to their actual source-coordinate datums instead of drawing
    # arbitrary-length annotation lines.
    section_cx = 155.0
    section_cy = 108.0
    section_scale = 4.2

    def sx(value: float) -> float:
        return section_cx + value * section_scale

    def sy(value: float) -> float:
        return section_cy + value * section_scale

    _dimension_h(
        sheet,
        arrow,
        sx(-meta.lower_width / 2),
        sx(meta.lower_width / 2),
        135,
        sy(2.0),
        f"{meta.lower_width:.1f}",
    )
    _dimension_h(
        sheet,
        arrow,
        sx(-meta.capture_width / 2),
        sx(meta.capture_width / 2),
        87,
        sy(-2.0),
        f"{meta.capture_width:.1f}",
    )
    _dimension_v(
        sheet,
        arrow,
        sy(-meta.height / 2),
        sy(meta.height / 2),
        223,
        sx(14.0),
        f"{meta.height:.1f}",
    )

    # Tie the detail view explicitly to the right-hand source profile.
    sheet.append(
        draw.Circle(
            209,
            108,
            9,
            fill="none",
            stroke="black",
            stroke_width=THIN,
        )
    )
    _text(sheet, "B", 2.8, 217, 99, weight="bold")

    # Detail B: exact crop of the right-hand capture profile.
    _text(sheet, "DETAIL B — CAPTURE PROFILE", 3.4, 228, 20, weight="bold")
    _text(sheet, "exact source crop • scale 11.3:1", 2.3, 228, 25)
    _embedded_svg(sheet, detail, 231, 30, 35, 68)

    # Source-derived local dimensions are grouped beside the exact crop so the
    # tiny bands remain readable instead of competing with the geometry.
    _text(sheet, "LOCAL PROFILE", 2.4, 229, 108, weight="bold")
    _text(
        sheet,
        f"lower radial offset   {meta.lower_radial_offset:.1f}",
        2.4,
        229,
        114,
    )
    _text(
        sheet,
        f"top radial offset     {meta.top_radial_offset:.1f}",
        2.4,
        229,
        120,
    )
    _text(
        sheet,
        "Z bands               "
        + " / ".join(f"{value:.1f}" for value in meta.bands),
        2.4,
        229,
        126,
    )

    # Provenance and interpretation boundary.
    _text(
        sheet,
        "EXACT PINNED OPENGRID LITE RECEIVER GEOMETRY",
        2.8,
        18,
        157,
        weight="bold",
    )
    _text(
        sheet,
        f"QuackWorks pin {PINNED_QUACKWORKS[:12]} • experiment-owned drawing",
        2.2,
        18,
        163,
    )
    _text(
        sheet,
        "Dimensions are source-derived and shown in mm; this is not an upstream manufacturing drawing.",
        2.2,
        18,
        169,
    )

    _title_block(sheet)

    output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save_svg(str(output))


def _export(svg: Path, png: Path, pdf: Path) -> None:
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
    _run(
        [
            "inkscape",
            str(svg),
            "--export-area-page",
            "--export-type=pdf",
            f"--export-filename={pdf}",
        ]
    )
    for path in (svg, png, pdf):
        if not path.is_file() or path.stat().st_size == 0:
            raise RuntimeError(f"missing drawing output: {path}")


def main() -> None:
    svg = OUTPUT_ROOT / f"{STEM}.svg"
    png = OUTPUT_ROOT / f"{STEM}.png"
    pdf = OUTPUT_ROOT / f"{STEM}.pdf"

    with tempfile.TemporaryDirectory(prefix="opengrid-drawing-") as tmp:
        tmpdir = Path(tmp)
        orientation = tmpdir / "orientation.svg"
        section = tmpdir / "section.svg"
        detail = tmpdir / "detail.svg"

        log = _source_svg("orientation", orientation)
        _source_svg("section", section)
        _source_svg("detail", detail)
        meta = _metadata(log)
        _compose(orientation, section, detail, meta, svg)

    _export(svg, png, pdf)
    print(f"drawing: {svg.relative_to(ROOT)}")
    print(f"drawing: {png.relative_to(ROOT)}")
    print(f"drawing: {pdf.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
