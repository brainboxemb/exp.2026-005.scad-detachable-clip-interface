#!/usr/bin/env python3
"""Reconstruct OpenGrid Lite top-view edge contours in model millimetres.

The technical top view is built from the horizontal profile boundaries that
exist in the pinned OpenGrid Lite model, not from one flattened 3D silhouette.

Python independently reconstructs each relevant XY section from the pinned
source dimensions. OpenSCAD then cuts the actual pinned 3D model at the same
source-derived heights. The two sets are published separately and overlaid as
an independent geometry check.

OpenSCAD output is never used as input to the Python geometry construction.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import isclose, sqrt
from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET

import drawsvg as draw


ROOT = Path(__file__).resolve().parents[2]
OUTPUT_ROOT = ROOT / "bld" / "drawing"
SLICE_REFERENCE_SCAD = (
    ROOT / "dsg" / "drawing" / "opengrid_lite_plan_slice_reference.scad"
)

PYTHON_SVG = OUTPUT_ROOT / "00-opengrid-python.svg"
OPENSCAD_SVG = OUTPUT_ROOT / "01-opengrid-openscad-reference.svg"
OVERLAY_SVG = OUTPUT_ROOT / "02-opengrid-overlay.svg"
OVERLAY_PNG = OUTPUT_ROOT / "02-opengrid-overlay.png"

# Pinned openGridTileAp1() source dimensions, in millimetres.
TILE_SIZE_MM = 28.0
TILE_THICKNESS_MM = 6.8
LITE_TILE_THICKNESS_MM = 4.0

OUTSIDE_EXTRUSION_MM = 0.8
INSIDE_GRID_TOP_CHAMFER_MM = 0.4
INSIDE_GRID_MIDDLE_CHAMFER_MM = 1.0
TOP_CAPTURE_INITIAL_INSET_MM = 2.4
CORNER_SQUARE_THICKNESS_MM = 2.6
INTERSECTION_DISTANCE_MM = 4.2
TILE_INNER_SIZE_DIFFERENCE_MM = 3.0

# Drawing presentation. Model geometry stays in real mm.
DRAWING_SCALE = 5.0
PAGE_MARGIN_MM = 0.5
MODEL_STROKE_MM = 0.10
GEOMETRY_TOLERANCE_MM = 0.001

SVG_NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", SVG_NS)

_SVG_LINE_POINT_RE = re.compile(
    r"(?:M|L)\s*"
    r"([+-]?(?:\d+(?:\.\d*)?|\.\d+))\s*,\s*"
    r"([+-]?(?:\d+(?:\.\d*)?|\.\d+))"
)


@dataclass(frozen=True)
class SectionGeometry:
    local_z_mm: float
    outer: tuple[tuple[float, float], ...]
    inner: tuple[tuple[float, float], ...]
    side_inset_mm: float
    corner_extent_mm: float


def _run(args: list[str]) -> None:
    subprocess.run(args, cwd=ROOT, check=True)


def _inside_extrusion_mm() -> float:
    tile_inner_size_mm = TILE_SIZE_MM - TILE_INNER_SIZE_DIFFERENCE_MM
    return (
        (TILE_SIZE_MM - tile_inner_size_mm) / 2.0
        - OUTSIDE_EXTRUSION_MM
    )


def _corner_offset_mm() -> float:
    return (
        sqrt(INTERSECTION_DISTANCE_MM**2 / 2.0)
        + CORNER_SQUARE_THICKNESS_MM
    )


def _lite_breakpoints_mm() -> tuple[float, ...]:
    """Return source-derived Lite-local horizontal edge planes.

    The retained Lite body is the upper 4 mm of the 6.8 mm source tile.

    Full-source Z edges relevant to Lite:
      4.4 = 6.8 - 2.4
      5.4 = 4.4 + 1.0
      6.4 = 6.8 - 0.4
      6.8 = top

    Subtracting the retained-source start Z=2.8 gives Lite-local:
      1.6, 2.6, 3.6, 4.0 mm.

    The bottom Z=0.0 and Z=1.6 sections have identical plan geometry, so only
    the latter is emitted as a unique contour.
    """

    lite_source_start_mm = TILE_THICKNESS_MM - LITE_TILE_THICKNESS_MM
    lower_band_top_mm = (
        TILE_THICKNESS_MM - TOP_CAPTURE_INITIAL_INSET_MM
        - lite_source_start_mm
    )
    ramp_top_mm = lower_band_top_mm + INSIDE_GRID_MIDDLE_CHAMFER_MM
    capture_top_mm = (
        TILE_THICKNESS_MM - INSIDE_GRID_TOP_CHAMFER_MM
        - lite_source_start_mm
    )
    top_mm = LITE_TILE_THICKNESS_MM

    values = (
        lower_band_top_mm,
        ramp_top_mm,
        capture_top_mm,
        top_mm,
    )
    expected = (1.6, 2.6, 3.6, 4.0)
    for value, check in zip(values, expected):
        assert isclose(value, check, abs_tol=1e-9)
    return values


def _side_inset_mm(local_z_mm: float) -> float:
    """Straight-edge material depth at one Lite-local Z plane."""

    inside_extrusion_mm = _inside_extrusion_mm()
    maximum_inset_mm = OUTSIDE_EXTRUSION_MM + inside_extrusion_mm

    lower_z, ramp_top_z, capture_top_z, top_z = _lite_breakpoints_mm()

    if not 0.0 <= local_z_mm <= top_z:
        raise ValueError(f"Lite-local Z outside 0..{top_z:g}: {local_z_mm}")

    if local_z_mm <= lower_z:
        return OUTSIDE_EXTRUSION_MM

    if local_z_mm <= ramp_top_z:
        fraction = (local_z_mm - lower_z) / (ramp_top_z - lower_z)
        return OUTSIDE_EXTRUSION_MM + fraction * inside_extrusion_mm

    if local_z_mm <= capture_top_z:
        return maximum_inset_mm

    # Top 0.4 mm is a 45-degree chamfer: 1.5 -> 1.1 mm.
    return maximum_inset_mm - (local_z_mm - capture_top_z)


def _corner_extent_mm(local_z_mm: float) -> float:
    """Source corner-profile reach before the 45-degree XY rotation."""

    _, ramp_top_z, _, top_z = _lite_breakpoints_mm()
    if not 0.0 <= local_z_mm <= top_z:
        raise ValueError(f"Lite-local Z outside 0..{top_z:g}: {local_z_mm}")

    corner_offset_mm = _corner_offset_mm()

    # The retained corner is constant through local Z=2.6, then follows the
    # source 45-degree 1.4 mm top chamfer to Z=4.0.
    if local_z_mm <= ramp_top_z:
        return corner_offset_mm

    return corner_offset_mm - (local_z_mm - ramp_top_z)


def _section_geometry(local_z_mm: float) -> SectionGeometry:
    side_inset_mm = _side_inset_mm(local_z_mm)
    corner_extent_mm = _corner_extent_mm(local_z_mm)

    half_mm = TILE_SIZE_MM / 2.0
    inner_flat_mm = half_mm - side_inset_mm

    # The separate source corner is rotated 45 degrees in XY. Its reach along
    # either tile edge is corner_extent * sqrt(2). The straight side strip
    # overlaps side_inset of that reach.
    corner_run_mm = corner_extent_mm * sqrt(2.0) - side_inset_mm
    inner_short_mm = half_mm - corner_run_mm

    outer = (
        (-half_mm, -half_mm),
        (half_mm, -half_mm),
        (half_mm, half_mm),
        (-half_mm, half_mm),
    )
    inner = (
        (-inner_short_mm, -inner_flat_mm),
        (inner_short_mm, -inner_flat_mm),
        (inner_flat_mm, -inner_short_mm),
        (inner_flat_mm, inner_short_mm),
        (inner_short_mm, inner_flat_mm),
        (-inner_short_mm, inner_flat_mm),
        (-inner_flat_mm, inner_short_mm),
        (-inner_flat_mm, -inner_short_mm),
    )

    return SectionGeometry(
        local_z_mm=local_z_mm,
        outer=outer,
        inner=inner,
        side_inset_mm=side_inset_mm,
        corner_extent_mm=corner_extent_mm,
    )


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


def _page_geometry() -> tuple[float, float]:
    page_size_mm = TILE_SIZE_MM + 2.0 * PAGE_MARGIN_MM
    return page_size_mm, page_size_mm / 2.0


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


def _compose_python_svg(
    path: Path,
    sections: tuple[SectionGeometry, ...],
) -> None:
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

    # The outside boundary is identical at every retained Z plane.
    drawing.append(_closed_lines(sections[0].outer))

    # Merge the unique inner contours. These are the top-view "inside lines"
    # created by the horizontal edges of the 3D profile.
    for section in sections:
        drawing.append(_closed_lines(section.inner))

    path.parent.mkdir(parents=True, exist_ok=True)
    drawing.save_svg(str(path))


def _geometry_paths(path: Path) -> list[str]:
    root = ET.parse(path).getroot()
    values = [
        element.attrib["d"]
        for element in root.iter()
        if element.tag == f"{{{SVG_NS}}}path" and element.attrib.get("d")
    ]
    if not values:
        raise RuntimeError(f"no SVG geometry paths found in {path}")
    return values


def _svg_line_vertices(path: Path) -> list[tuple[float, float]]:
    vertices: list[tuple[float, float]] = []
    for path_data in _geometry_paths(path):
        vertices.extend(
            (float(match.group(1)), float(match.group(2)))
            for match in _SVG_LINE_POINT_RE.finditer(path_data)
        )
    if not vertices:
        raise RuntimeError(f"no line vertices found in {path}")
    return vertices


def _unique_vertices(
    vertices: list[tuple[float, float]] | tuple[tuple[float, float], ...],
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


def _maximum_vertex_delta_mm(
    expected: list[tuple[float, float]] | tuple[tuple[float, float], ...],
    reference: list[tuple[float, float]] | tuple[tuple[float, float], ...],
) -> float:
    expected_unique = _unique_vertices(expected)
    reference_unique = _unique_vertices(reference)

    if len(reference_unique) != len(expected_unique):
        raise RuntimeError(
            "OpenSCAD/Python section vertex-count mismatch: "
            f"python={len(expected_unique)}, openscad={len(reference_unique)}"
        )

    forward = max(
        min(_point_distance_mm(point, candidate) for candidate in reference_unique)
        for point in expected_unique
    )
    reverse = max(
        min(_point_distance_mm(point, candidate) for candidate in expected_unique)
        for point in reference_unique
    )
    return max(forward, reverse)


def _build_openscad_sections(
    sections: tuple[SectionGeometry, ...],
) -> tuple[list[tuple[float, list[str]]], float]:
    """Cut the actual 3D receiver and return paths for each source-derived Z."""

    rendered: list[tuple[float, list[str]]] = []
    maximum_delta_mm = 0.0

    for section in sections:
        temp_svg = (
            OUTPUT_ROOT
            / f"_tmp-opengrid-section-{section.local_z_mm:.1f}.svg"
        )
        _run(
            [
                "openscad",
                "-D",
                f"slice_z_mm={section.local_z_mm}",
                "-o",
                str(temp_svg),
                str(SLICE_REFERENCE_SCAD),
            ]
        )

        try:
            paths = _geometry_paths(temp_svg)
            reference_vertices = _svg_line_vertices(temp_svg)
            expected_vertices = [*section.outer, *section.inner]
            delta_mm = _maximum_vertex_delta_mm(
                expected_vertices,
                reference_vertices,
            )
        finally:
            temp_svg.unlink(missing_ok=True)

        if delta_mm > GEOMETRY_TOLERANCE_MM:
            raise RuntimeError(
                f"section Z={section.local_z_mm:.3f} mm mismatch: "
                f"{delta_mm:.9f} mm exceeds "
                f"{GEOMETRY_TOLERANCE_MM:.9f} mm"
            )

        maximum_delta_mm = max(maximum_delta_mm, delta_mm)
        rendered.append((section.local_z_mm, paths))

    return rendered, maximum_delta_mm


def _compose_openscad_svg(
    path: Path,
    rendered: list[tuple[float, list[str]]],
) -> None:
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
        for path_data in paths:
            ET.SubElement(
                group,
                f"{{{SVG_NS}}}path",
                {"d": path_data},
            )

    ET.ElementTree(root).write(path, encoding="utf-8", xml_declaration=True)


def _compose_overlay(
    path: Path,
    sections: tuple[SectionGeometry, ...],
    rendered: list[tuple[float, list[str]]],
) -> None:
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
        for path_data in paths:
            ET.SubElement(layer, f"{{{SVG_NS}}}path", {"d": path_data})

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

    # Same merged line set as 00-opengrid-python.svg.
    ET.SubElement(
        python_group,
        f"{{{SVG_NS}}}path",
        {"d": _path_data(sections[0].outer)},
    )
    for section in sections:
        ET.SubElement(
            python_group,
            f"{{{SVG_NS}}}path",
            {"d": _path_data(section.inner)},
        )

    ET.ElementTree(root).write(path, encoding="utf-8", xml_declaration=True)


def _path_data(points: tuple[tuple[float, float], ...]) -> str:
    first_x, first_y = points[0]
    chunks = [f"M{first_x:.12g},{first_y:.12g}"]
    for x_mm, y_mm in points[1:]:
        chunks.append(f"L{x_mm:.12g},{y_mm:.12g}")
    chunks.append("Z")
    return " ".join(chunks)


def main() -> None:
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)

    sections = tuple(
        _section_geometry(local_z_mm)
        for local_z_mm in _lite_breakpoints_mm()
    )

    # Verify the deliberately omitted duplicate lower plane.
    bottom = _section_geometry(0.0)
    assert bottom.outer == sections[0].outer
    assert bottom.inner == sections[0].inner

    _compose_python_svg(PYTHON_SVG, sections)

    rendered, maximum_delta_mm = _build_openscad_sections(sections)
    _compose_openscad_svg(OPENSCAD_SVG, rendered)
    _compose_overlay(OVERLAY_SVG, sections, rendered)

    _run(
        [
            "inkscape",
            str(OVERLAY_SVG),
            "--export-area-page",
            "--export-type=png",
            "--export-dpi=160",
            f"--export-filename={OVERLAY_PNG}",
        ]
    )

    outputs = (
        PYTHON_SVG,
        OPENSCAD_SVG,
        OVERLAY_SVG,
        OVERLAY_PNG,
    )
    for output in outputs:
        if not output.is_file() or output.stat().st_size == 0:
            raise RuntimeError(f"missing drawing output: {output}")

    print(
        "OpenGrid Lite top-view contour planes: "
        + ", ".join(f"{section.local_z_mm:g} mm" for section in sections)
    )
    print(
        "bottom contour Z=0.0 mm is geometrically identical to "
        "Z=1.6 mm and is drawn once"
    )
    for section in sections:
        print(
            f"Z={section.local_z_mm:g} mm: "
            f"side inset={section.side_inset_mm:.6f} mm, "
            f"corner extent={section.corner_extent_mm:.6f} mm"
        )
    print(
        "geometry validation: "
        f"max section vertex delta={maximum_delta_mm:.9f} mm "
        f"(limit={GEOMETRY_TOLERANCE_MM:.9f} mm)"
    )
    for output in outputs:
        print(f"drawing: {output.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
