#!/usr/bin/env python3
"""Build and validate the OpenGrid Lite multi-height top-view drawing.

Responsibilities in this file are deliberately limited to orchestration:
- request exact horizontal cuts from the pinned OpenSCAD reference;
- numerically compare those cuts with the independent Python geometry;
- ask the SVG backend to publish Python, OpenSCAD and overlay artifacts.
"""

from __future__ import annotations

from pathlib import Path
import subprocess

from opengrid_profile_geometry import (
    LITE_TILE_THICKNESS_MM,
    SectionGeometry,
    unique_lite_sections,
)
from opengrid_profile_render import (
    compose_openscad_svg,
    compose_overlay,
    compose_python_svg,
    export_png,
    geometry_paths,
    maximum_vertex_delta_mm,
    svg_line_vertices,
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
) -> tuple[list[tuple[float, list[str]]], float]:
    """Cut the actual 3D receiver at each source-derived contour plane."""

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
            paths = geometry_paths(temp_svg)
            reference_vertices = svg_line_vertices(temp_svg)
            expected_vertices = [*section.outer, *section.inner]
            delta_mm = maximum_vertex_delta_mm(
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


def main() -> None:
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)

    sections = unique_lite_sections()

    compose_python_svg(PYTHON_SVG, sections)

    rendered, maximum_delta_mm = _build_openscad_sections(sections)
    compose_openscad_svg(OPENSCAD_SVG, rendered)
    compose_overlay(OVERLAY_SVG, sections, rendered)
    export_png(OVERLAY_SVG, OVERLAY_PNG)

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
        "and is drawn once"
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

    assert sections[-1].local_z_mm == LITE_TILE_THICKNESS_MM

    for output in outputs:
        print(f"drawing: {output.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
