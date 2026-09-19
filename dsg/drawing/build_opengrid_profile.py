#!/usr/bin/env python3
"""Reconstruct and validate the OpenGrid Lite plan outline in model millimetres.

The Python geometry is intentionally independent from OpenSCAD output.  It
reconstructs the plan footprint from the same source dimensions and construction
relationships found in the pinned QuackWorks openGridTileAp1() implementation.

OpenSCAD is invoked only afterwards as an independent reference/oracle.  The
Python SVG and OpenSCAD SVG are then merged into a validation overlay.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import isclose, sqrt
from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET

import drawsvg as draw


ROOT = Path(__file__).resolve().parents[2]
OUTPUT_ROOT = ROOT / "bld" / "drawing"
REFERENCE_SCAD = ROOT / "dsg" / "drawing" / "opengrid_lite_plan_reference.scad"

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

# Drawing presentation.  Model geometry above and below remains in real mm.
DRAWING_SCALE = 5.0
PAGE_MARGIN_MM = 0.5
MODEL_STROKE_MM = 0.12

SVG_NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", SVG_NS)


@dataclass(frozen=True)
class PlanGeometry:
    outer: tuple[tuple[float, float], ...]
    inner: tuple[tuple[float, float], ...]
    side_projection_mm: float
    corner_offset_mm: float
    corner_run_mm: float


def _run(args: list[str]) -> None:
    subprocess.run(args, cwd=ROOT, check=True)


def _derive_plan_geometry() -> PlanGeometry:
    """Translate the pinned 3D source construction into its Lite XY footprint."""

    tile_inner_size_mm = TILE_SIZE_MM - TILE_INNER_SIZE_DIFFERENCE_MM
    inside_extrusion_mm = (
        (TILE_SIZE_MM - tile_inner_size_mm) / 2.0
        - OUTSIDE_EXTRUSION_MM
    )

    corner_chamfer_mm = (
        TOP_CAPTURE_INITIAL_INSET_MM
        - INSIDE_GRID_MIDDLE_CHAMFER_MM
    )
    calculated_corner_chamfer_mm = sqrt(
        INTERSECTION_DISTANCE_MM**2 / 2.0
    )
    corner_offset_mm = (
        calculated_corner_chamfer_mm
        + CORNER_SQUARE_THICKNESS_MM
    )

    # openGridLite() keeps the upper 4.0 mm of the 6.8 mm full tile.
    lite_source_z_min_mm = TILE_THICKNESS_MM - LITE_TILE_THICKNESS_MM
    lite_source_z_max_mm = TILE_THICKNESS_MM

    # The straight source profile reaches this maximum inward width from
    # z=5.4..6.4 mm.  That interval lies inside the retained Lite range
    # z=2.8..6.8 mm, so it defines the XY projection footprint.
    side_projection_mm = OUTSIDE_EXTRUSION_MM + inside_extrusion_mm
    straight_max_z_min_mm = (
        TILE_THICKNESS_MM
        - TOP_CAPTURE_INITIAL_INSET_MM
        + INSIDE_GRID_MIDDLE_CHAMFER_MM
    )
    straight_max_z_max_mm = (
        TILE_THICKNESS_MM
        - INSIDE_GRID_TOP_CHAMFER_MM
    )
    if not (
        straight_max_z_min_mm <= lite_source_z_max_mm
        and straight_max_z_max_mm >= lite_source_z_min_mm
    ):
        raise RuntimeError("Lite slice does not retain the maximum straight profile")

    # The separate source corner profile reaches cornerOffset from
    # z=cornerChamfer..Tile_Thickness-cornerChamfer.  The retained Lite range
    # overlaps this interval too, so the full corner offset participates in the
    # XY plan projection.
    corner_max_z_min_mm = corner_chamfer_mm
    corner_max_z_max_mm = TILE_THICKNESS_MM - corner_chamfer_mm
    if not (
        corner_max_z_min_mm <= lite_source_z_max_mm
        and corner_max_z_max_mm >= lite_source_z_min_mm
    ):
        raise RuntimeError("Lite slice does not retain the maximum corner profile")

    # openGridTileAp1() creates the corner as a 45-degree rotated rectangular
    # extrusion.  Clipped by the 28x28 tile square, its plan footprint is a
    # right triangle whose X+Y reach from each outer corner is:
    corner_diagonal_reach_mm = corner_offset_mm * sqrt(2.0)

    # The straight 1.5 mm side strip overlaps that triangle.  The remaining
    # diagonal therefore meets each straight inner edge this far from the
    # corresponding square corner.
    corner_run_mm = corner_diagonal_reach_mm - side_projection_mm

    half_mm = TILE_SIZE_MM / 2.0
    inner_flat_mm = half_mm - side_projection_mm
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

    # Source-derived sanity values, not drawing coordinates.
    assert isclose(tile_inner_size_mm, 25.0)
    assert isclose(inside_extrusion_mm, 0.7)
    assert isclose(side_projection_mm, 1.5)
    assert isclose(corner_offset_mm, 5.5698484809835)

    return PlanGeometry(
        outer=outer,
        inner=inner,
        side_projection_mm=side_projection_mm,
        corner_offset_mm=corner_offset_mm,
        corner_run_mm=corner_run_mm,
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
    page_half_mm = page_size_mm / 2.0
    return page_size_mm, page_half_mm


def _compose_python_svg(path: Path, geometry: PlanGeometry) -> None:
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
    drawing.append(_closed_lines(geometry.outer))
    drawing.append(_closed_lines(geometry.inner))

    path.parent.mkdir(parents=True, exist_ok=True)
    drawing.save_svg(str(path))


def _normalize_openscad_svg(path: Path) -> None:
    """Keep OpenSCAD geometry unchanged; normalize only page and line styling."""

    tree = ET.parse(path)
    root = tree.getroot()

    view_box = [float(value) for value in root.attrib["viewBox"].split()]
    if len(view_box) != 4:
        raise RuntimeError(f"invalid OpenSCAD SVG viewBox: {view_box}")

    # OpenSCAD currently adds a 1 mm export-page margin around this 28x28 mm
    # model, so the raw SVG page is -15..+15 rather than -14..+14.  The page
    # extent is presentation metadata, not model geometry.  Require only that
    # the exported page contains the complete source tile before replacing the
    # page with our common drawing viewBox.
    raw_min_x, raw_min_y, raw_width, raw_height = view_box
    raw_max_x = raw_min_x + raw_width
    raw_max_y = raw_min_y + raw_height
    model_half = TILE_SIZE_MM / 2.0
    if not (
        raw_min_x <= -model_half
        and raw_min_y <= -model_half
        and raw_max_x >= model_half
        and raw_max_y >= model_half
    ):
        raise RuntimeError(
            "OpenSCAD SVG page does not contain the expected "
            f"{TILE_SIZE_MM:g}x{TILE_SIZE_MM:g} mm tile: {view_box}"
        )

    page_size_mm, page_half_mm = _page_geometry()
    root.set(
        "viewBox",
        f"{-page_half_mm:g} {-page_half_mm:g} "
        f"{page_size_mm:g} {page_size_mm:g}",
    )
    root.set("width", f"{page_size_mm * DRAWING_SCALE:g}mm")
    root.set("height", f"{page_size_mm * DRAWING_SCALE:g}mm")

    for element in root.iter():
        if element.tag == f"{{{SVG_NS}}}path":
            element.set("fill", "none")
            element.set("stroke", "black")
            element.set("stroke-width", f"{MODEL_STROKE_MM:g}")
            element.set("stroke-linejoin", "miter")

    tree.write(path, encoding="utf-8", xml_declaration=True)


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


def _compose_overlay(
    path: Path,
    python_svg: Path,
    openscad_svg: Path,
) -> None:
    """Merge the independently generated SVG geometry into one comparison."""

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

    reference_group = ET.SubElement(
        root,
        f"{{{SVG_NS}}}g",
        {
            "id": "openscad-reference",
            "fill": "none",
            "stroke": "#d62728",
            "stroke-width": "0.10",
            "stroke-dasharray": "0.35 0.20",
            "stroke-linejoin": "miter",
        },
    )
    for path_data in _geometry_paths(openscad_svg):
        ET.SubElement(
            reference_group,
            f"{{{SVG_NS}}}path",
            {"d": path_data},
        )

    python_group = ET.SubElement(
        root,
        f"{{{SVG_NS}}}g",
        {
            "id": "python-geometry",
            "fill": "none",
            "stroke": "#1f77b4",
            "stroke-width": "0.12",
            "stroke-linejoin": "miter",
        },
    )
    for path_data in _geometry_paths(python_svg):
        ET.SubElement(
            python_group,
            f"{{{SVG_NS}}}path",
            {"d": path_data},
        )

    ET.ElementTree(root).write(path, encoding="utf-8", xml_declaration=True)


def main() -> None:
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)

    geometry = _derive_plan_geometry()
    _compose_python_svg(PYTHON_SVG, geometry)

    _run(
        [
            "openscad",
            "-o",
            str(OPENSCAD_SVG),
            str(REFERENCE_SCAD),
        ]
    )
    _normalize_openscad_svg(OPENSCAD_SVG)

    _compose_overlay(
        OVERLAY_SVG,
        python_svg=PYTHON_SVG,
        openscad_svg=OPENSCAD_SVG,
    )

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
        "OpenGrid Lite plan: "
        f"side={geometry.side_projection_mm:.6f} mm, "
        f"cornerOffset={geometry.corner_offset_mm:.6f} mm, "
        f"cornerRun={geometry.corner_run_mm:.6f} mm"
    )
    for output in outputs:
        print(f"drawing: {output.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
