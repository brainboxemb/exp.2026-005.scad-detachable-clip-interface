#!/usr/bin/env python3
"""Build and validate the OpenGrid Lite visible-edge top-view drawing.

This file only orchestrates the experiment:
- request horizontal cuts from the pinned OpenSCAD reference;
- validate every raw cut against the independent Python profile;
- remove lower edge segments hidden by higher material;
- publish Python, OpenSCAD and overlay SVG evidence.
"""

from __future__ import annotations

from pathlib import Path
import subprocess

from opengrid_profile_geometry import (
    LITE_TILE_THICKNESS_MM,
    Polygon,
    SectionGeometry,
    maximum_point_set_delta_mm,
    polygon_signed_area,
    segment_endpoints,
    unique_lite_sections,
    visible_contour_layers,
)
from opengrid_profile_render import (
    compose_overlay,
    compose_top_view_svg,
    export_png,
    svg_polygons,
)


ROOT = Path(__file__).resolve().parents[2]
OUTPUT_ROOT = ROOT / "bld" / "drawing"
SLICE_REFERENCE_SCAD = (
    ROOT / "dsg" / "drawing" / "opengrid_lite_plan_slice_reference.scad"
)

PYTHON_SVG = OUTPUT_ROOT / "00-opengrid-python.svg"
OPENSCAD_SVG = OUTPUT_ROOT / "01-opengrid-openscad-reference.svg"
OVERLAY_SVG = OUTPUT_ROOT / "02-opengrid-overlay.svg"
OVERLAY_PNG = OUTPUT_ROOT / "02-opengrid-overlay.png"

GEOMETRY_TOLERANCE_MM = 0.001


def _run(args: list[str]) -> None:
    subprocess.run(args, cwd=ROOT, check=True)


def _build_openscad_sections(
    sections: tuple[SectionGeometry, ...],
) -> tuple[
    tuple[Polygon, ...],
    tuple[Polygon, ...],
    float,
]:
    """Cut the actual 3D receiver and recover outer/inner section polygons."""

    outer_polygons: list[Polygon] = []
    inner_polygons: list[Polygon] = []
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
            polygons = svg_polygons(temp_svg)
        finally:
            temp_svg.unlink(missing_ok=True)

        if len(polygons) != 2:
            raise RuntimeError(
                f"expected two section polygons at "
                f"Z={section.local_z_mm:g} mm, got {len(polygons)}"
            )

        ordered = sorted(
            polygons,
            key=lambda polygon: abs(polygon_signed_area(polygon)),
            reverse=True,
        )
        outer_polygon, inner_polygon = ordered

        delta_mm = maximum_point_set_delta_mm(
            [*section.outer, *section.inner],
            [*outer_polygon, *inner_polygon],
        )

        if delta_mm > GEOMETRY_TOLERANCE_MM:
            raise RuntimeError(
                f"raw section Z={section.local_z_mm:.3f} mm mismatch: "
                f"{delta_mm:.9f} mm exceeds "
                f"{GEOMETRY_TOLERANCE_MM:.9f} mm"
            )

        maximum_delta_mm = max(maximum_delta_mm, delta_mm)
        outer_polygons.append(outer_polygon)
        inner_polygons.append(inner_polygon)

    return (
        tuple(outer_polygons),
        tuple(inner_polygons),
        maximum_delta_mm,
    )


def main() -> None:
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)

    sections = unique_lite_sections()

    python_inner_polygons = tuple(
        section.inner
        for section in sections
    )
    python_layers = visible_contour_layers(
        python_inner_polygons
    )

    (
        openscad_outer_polygons,
        openscad_inner_polygons,
        raw_delta_mm,
    ) = _build_openscad_sections(sections)

    openscad_layers = visible_contour_layers(
        openscad_inner_polygons
    )

    visible_delta_mm = maximum_point_set_delta_mm(
        segment_endpoints(python_layers),
        segment_endpoints(openscad_layers),
    )

    if visible_delta_mm > GEOMETRY_TOLERANCE_MM:
        raise RuntimeError(
            "visible-edge merge mismatch: "
            f"{visible_delta_mm:.9f} mm exceeds "
            f"{GEOMETRY_TOLERANCE_MM:.9f} mm"
        )

    python_outer = sections[0].outer
    openscad_outer = openscad_outer_polygons[0]

    compose_top_view_svg(
        PYTHON_SVG,
        python_outer,
        python_layers,
    )
    compose_top_view_svg(
        OPENSCAD_SVG,
        openscad_outer,
        openscad_layers,
    )
    compose_overlay(
        OVERLAY_SVG,
        python_outer,
        python_layers,
        openscad_outer,
        openscad_layers,
    )
    export_png(
        OVERLAY_SVG,
        OVERLAY_PNG,
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
        + ", ".join(
            f"{section.local_z_mm:g} mm"
            for section in sections
        )
    )
    print(
        "Z=0.0 mm is geometrically identical to Z=1.6 mm "
        "and is represented once"
    )

    for section, layer in zip(sections, python_layers):
        print(
            f"Z={section.local_z_mm:g} mm: "
            f"side inset={section.side_inset_mm:.6f} mm, "
            f"corner extent={section.corner_extent_mm:.6f} mm, "
            f"visible segments={len(layer)}"
        )

    print(
        "geometry validation: "
        f"raw section max delta={raw_delta_mm:.9f} mm, "
        f"visible-edge max delta={visible_delta_mm:.9f} mm "
        f"(limit={GEOMETRY_TOLERANCE_MM:.9f} mm)"
    )

    assert sections[-1].local_z_mm == LITE_TILE_THICKNESS_MM

    for output in outputs:
        print(f"drawing: {output.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
