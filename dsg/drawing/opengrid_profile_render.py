"""SVG rendering backend for the OpenGrid profile experiment.

This module owns drawsvg/XML/presentation concerns only. Source profile
dimensions and geometric construction live in opengrid_profile_geometry.py.
"""

from __future__ import annotations

from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET

import drawsvg as draw

from opengrid_profile_geometry import (
    Point,
    Polygon,
    SegmentLayer,
    TILE_SIZE_MM,
)


DRAWING_SCALE = 5.0
PAGE_MARGIN_MM = 0.5
MODEL_STROKE_MM = 0.10

SVG_NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", SVG_NS)

_SVG_LINE_POINT_RE = re.compile(
    r"(?:M|L)\s*"
    r"([+-]?(?:\d+(?:\.\d*)?|\.\d+))\s*,\s*"
    r"([+-]?(?:\d+(?:\.\d*)?|\.\d+))"
)


def compose_top_view_svg(
    path: Path,
    outer: Polygon,
    layers: tuple[SegmentLayer, ...],
) -> None:
    """Render one clean visible-edge top view."""

    page_size_mm, page_half_mm = _page_geometry()
    drawing = draw.Drawing(
        page_size_mm,
        page_size_mm,
        origin=(-page_half_mm, -page_half_mm),
    )
    drawing.set_render_size(
        w=f"{page_size_mm * DRAWING_SCALE:g}mm",
        h=f"{page_size_mm * DRAWING_SCALE:g}mm",
    )

    drawing.append(
        draw.Rectangle(
            -page_half_mm,
            -page_half_mm,
            page_size_mm,
            page_size_mm,
            fill="white",
        )
    )
    drawing.append(_closed_lines(outer))

    for layer in layers:
        for start, end in layer:
            drawing.append(
                draw.Line(
                    start[0],
                    start[1],
                    end[0],
                    end[1],
                    stroke="black",
                    stroke_width=MODEL_STROKE_MM,
                )
            )

    path.parent.mkdir(parents=True, exist_ok=True)
    drawing.save_svg(str(path))


def compose_overlay(
    path: Path,
    python_outer: Polygon,
    python_layers: tuple[SegmentLayer, ...],
    openscad_outer: Polygon,
    openscad_layers: tuple[SegmentLayer, ...],
) -> None:
    """Overlay independently derived visible-edge sets."""

    root = _new_svg_root()

    _append_edge_group(
        root,
        group_id="openscad-reference",
        outer=openscad_outer,
        layers=openscad_layers,
        stroke="#d62728",
        width=0.08,
        dash="0.30 0.18",
    )
    _append_edge_group(
        root,
        group_id="python-geometry",
        outer=python_outer,
        layers=python_layers,
        stroke="#1f77b4",
        width=0.11,
        dash=None,
    )

    ET.ElementTree(root).write(
        path,
        encoding="utf-8",
        xml_declaration=True,
    )


def svg_polygons(path: Path) -> tuple[Polygon, ...]:
    """Read simple M/L/Z OpenSCAD SVG subpaths as polygons."""

    root = ET.parse(path).getroot()
    polygons: list[Polygon] = []

    for element in root.iter():
        if (
            element.tag != f"{{{SVG_NS}}}path"
            or not element.attrib.get("d")
        ):
            continue

        data = element.attrib["d"]

        for chunk in re.split(r"(?=[Mm])", data):
            points = tuple(
                (
                    float(match.group(1)),
                    float(match.group(2)),
                )
                for match in _SVG_LINE_POINT_RE.finditer(chunk)
            )
            if len(points) >= 3:
                polygons.append(points)

    if not polygons:
        raise RuntimeError(f"no SVG polygons found in {path}")

    return tuple(polygons)


def export_png(svg_path: Path, png_path: Path) -> None:
    subprocess.run(
        [
            "inkscape",
            str(svg_path),
            "--export-area-page",
            "--export-type=png",
            "--export-dpi=160",
            f"--export-filename={png_path}",
        ],
        check=True,
    )


def _page_geometry() -> tuple[float, float]:
    page_size_mm = TILE_SIZE_MM + 2.0 * PAGE_MARGIN_MM
    return page_size_mm, page_size_mm / 2.0


def _closed_lines(
    points: Polygon,
    *,
    stroke: str = "black",
    width: float = MODEL_STROKE_MM,
) -> draw.Lines:
    flat: list[float] = []

    for x_mm, y_mm in points:
        flat.extend([x_mm, y_mm])

    return draw.Lines(
        *flat,
        close=True,
        fill="none",
        stroke=stroke,
        stroke_width=width,
        stroke_linejoin="miter",
    )


def _new_svg_root() -> ET.Element:
    page_size_mm, page_half_mm = _page_geometry()

    root = ET.Element(
        f"{{{SVG_NS}}}svg",
        {
            "width": f"{page_size_mm * DRAWING_SCALE:g}mm",
            "height": f"{page_size_mm * DRAWING_SCALE:g}mm",
            "viewBox": (
                f"{-page_half_mm:g} {-page_half_mm:g} "
                f"{page_size_mm:g} {page_size_mm:g}"
            ),
            "version": "1.1",
        },
    )

    ET.SubElement(
        root,
        f"{{{SVG_NS}}}rect",
        {
            "x": f"{-page_half_mm:g}",
            "y": f"{-page_half_mm:g}",
            "width": f"{page_size_mm:g}",
            "height": f"{page_size_mm:g}",
            "fill": "white",
        },
    )

    return root


def _append_edge_group(
    root: ET.Element,
    *,
    group_id: str,
    outer: Polygon,
    layers: tuple[SegmentLayer, ...],
    stroke: str,
    width: float,
    dash: str | None,
) -> None:
    attributes = {
        "id": group_id,
        "fill": "none",
        "stroke": stroke,
        "stroke-width": f"{width:g}",
        "stroke-linejoin": "miter",
    }
    if dash is not None:
        attributes["stroke-dasharray"] = dash

    group = ET.SubElement(
        root,
        f"{{{SVG_NS}}}g",
        attributes,
    )

    ET.SubElement(
        group,
        f"{{{SVG_NS}}}path",
        {"d": _polygon_path_data(outer)},
    )

    for layer_index, layer in enumerate(layers):
        layer_group = ET.SubElement(
            group,
            f"{{{SVG_NS}}}g",
            {"id": f"{group_id}-layer-{layer_index}"},
        )

        for start, end in layer:
            ET.SubElement(
                layer_group,
                f"{{{SVG_NS}}}line",
                {
                    "x1": f"{start[0]:.12g}",
                    "y1": f"{start[1]:.12g}",
                    "x2": f"{end[0]:.12g}",
                    "y2": f"{end[1]:.12g}",
                },
            )


def _polygon_path_data(points: Polygon) -> str:
    first_x, first_y = points[0]
    chunks = [f"M{first_x:.12g},{first_y:.12g}"]

    for x_mm, y_mm in points[1:]:
        chunks.append(f"L{x_mm:.12g},{y_mm:.12g}")

    chunks.append("Z")
    return " ".join(chunks)
