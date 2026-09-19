"""SVG rendering backend for the OpenGrid profile experiment.

This module owns drawsvg/XML/presentation concerns only. Source profile
dimensions and geometric construction live in opengrid_profile_geometry.py.
"""

from __future__ import annotations

from math import sqrt
from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET

import drawsvg as draw

from opengrid_profile_geometry import SectionGeometry, TILE_SIZE_MM


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


def _page_geometry() -> tuple[float, float]:
    page_size_mm = TILE_SIZE_MM + 2.0 * PAGE_MARGIN_MM
    return page_size_mm, page_size_mm / 2.0


def _closed_lines(
    points: tuple[tuple[float, float], ...],
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


def path_data(points: tuple[tuple[float, float], ...]) -> str:
    first_x, first_y = points[0]
    chunks = [f"M{first_x:.12g},{first_y:.12g}"]
    for x_mm, y_mm in points[1:]:
        chunks.append(f"L{x_mm:.12g},{y_mm:.12g}")
    chunks.append("Z")
    return " ".join(chunks)


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


def compose_python_svg(
    path: Path,
    sections: tuple[SectionGeometry, ...],
) -> None:
    """Render the merged Python top-view contour set."""

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

    # Outer boundary is identical at every retained Z plane.
    drawing.append(_closed_lines(sections[0].outer))

    # Each unique horizontal profile edge contributes one visible inner line.
    for section in sections:
        drawing.append(_closed_lines(section.inner))

    path.parent.mkdir(parents=True, exist_ok=True)
    drawing.save_svg(str(path))


def geometry_paths(path: Path) -> list[str]:
    root = ET.parse(path).getroot()
    values = [
        element.attrib["d"]
        for element in root.iter()
        if element.tag == f"{{{SVG_NS}}}path" and element.attrib.get("d")
    ]

    if not values:
        raise RuntimeError(f"no SVG geometry paths found in {path}")

    return values


def svg_line_vertices(path: Path) -> list[tuple[float, float]]:
    vertices: list[tuple[float, float]] = []

    for data in geometry_paths(path):
        vertices.extend(
            (float(match.group(1)), float(match.group(2)))
            for match in _SVG_LINE_POINT_RE.finditer(data)
        )

    if not vertices:
        raise RuntimeError(f"no line vertices found in {path}")

    return vertices


def _unique_vertices(
    vertices: list[tuple[float, float]]
    | tuple[tuple[float, float], ...],
) -> list[tuple[float, float]]:
    unique: list[tuple[float, float]] = []
    for vertex in vertices:
        if vertex not in unique:
            unique.append(vertex)
    return unique


def _point_distance_mm(
    left: tuple[float, float],
    right: tuple[float, float],
) -> float:
    dx = left[0] - right[0]
    dy = left[1] - right[1]
    return sqrt(dx * dx + dy * dy)


def maximum_vertex_delta_mm(
    expected: list[tuple[float, float]]
    | tuple[tuple[float, float], ...],
    reference: list[tuple[float, float]]
    | tuple[tuple[float, float], ...],
) -> float:
    expected_unique = _unique_vertices(expected)
    reference_unique = _unique_vertices(reference)

    if len(reference_unique) != len(expected_unique):
        raise RuntimeError(
            "OpenSCAD/Python section vertex-count mismatch: "
            f"python={len(expected_unique)}, "
            f"openscad={len(reference_unique)}"
        )

    forward = max(
        min(
            _point_distance_mm(point, candidate)
            for candidate in reference_unique
        )
        for point in expected_unique
    )
    reverse = max(
        min(
            _point_distance_mm(point, candidate)
            for candidate in expected_unique
        )
        for point in reference_unique
    )

    return max(forward, reverse)


def compose_openscad_svg(
    path: Path,
    rendered: list[tuple[float, list[str]]],
) -> None:
    """Merge independently cut OpenSCAD contours into one top view."""

    root = _new_svg_root()

    for local_z_mm, paths in rendered:
        group = ET.SubElement(
            root,
            f"{{{SVG_NS}}}g",
            {
                "id": f"section-z-{local_z_mm:.1f}",
                "fill": "none",
                "stroke": "black",
                "stroke-width": f"{MODEL_STROKE_MM:g}",
                "stroke-linejoin": "miter",
            },
        )

        for data in paths:
            ET.SubElement(
                group,
                f"{{{SVG_NS}}}path",
                {"d": data},
            )

    ET.ElementTree(root).write(
        path,
        encoding="utf-8",
        xml_declaration=True,
    )


def compose_overlay(
    path: Path,
    sections: tuple[SectionGeometry, ...],
    rendered: list[tuple[float, list[str]]],
) -> None:
    """Overlay Python geometry and OpenSCAD oracle contours."""

    root = _new_svg_root()

    reference_group = ET.SubElement(
        root,
        f"{{{SVG_NS}}}g",
        {
            "id": "openscad-reference",
            "fill": "none",
            "stroke": "#d62728",
            "stroke-width": "0.08",
            "stroke-dasharray": "0.30 0.18",
            "stroke-linejoin": "miter",
        },
    )

    for local_z_mm, paths in rendered:
        layer = ET.SubElement(
            reference_group,
            f"{{{SVG_NS}}}g",
            {"id": f"openscad-z-{local_z_mm:.1f}"},
        )
        for data in paths:
            ET.SubElement(
                layer,
                f"{{{SVG_NS}}}path",
                {"d": data},
            )

    python_group = ET.SubElement(
        root,
        f"{{{SVG_NS}}}g",
        {
            "id": "python-geometry",
            "fill": "none",
            "stroke": "#1f77b4",
            "stroke-width": "0.11",
            "stroke-linejoin": "miter",
        },
    )

    ET.SubElement(
        python_group,
        f"{{{SVG_NS}}}path",
        {"d": path_data(sections[0].outer)},
    )
    for section in sections:
        ET.SubElement(
            python_group,
            f"{{{SVG_NS}}}path",
            {"d": path_data(section.inner)},
        )

    ET.ElementTree(root).write(
        path,
        encoding="utf-8",
        xml_declaration=True,
    )


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
