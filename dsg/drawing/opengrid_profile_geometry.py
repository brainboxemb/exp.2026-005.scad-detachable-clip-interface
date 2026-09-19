"""OpenGrid Lite plan/profile geometry in real millimetres.

This module contains only source dimensions and deterministic 2D geometry.
It deliberately has no drawsvg, SVG/XML, Inkscape or OpenSCAD process logic.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import isclose, sqrt


# Pinned openGridTileAp1() source dimensions.
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


@dataclass(frozen=True)
class SectionGeometry:
    """One horizontal OpenGrid Lite section in XY model coordinates."""

    local_z_mm: float
    outer: tuple[tuple[float, float], ...]
    inner: tuple[tuple[float, float], ...]
    side_inset_mm: float
    corner_extent_mm: float


def inside_extrusion_mm() -> float:
    tile_inner_size_mm = TILE_SIZE_MM - TILE_INNER_SIZE_DIFFERENCE_MM
    return (
        (TILE_SIZE_MM - tile_inner_size_mm) / 2.0
        - OUTSIDE_EXTRUSION_MM
    )


def corner_offset_mm() -> float:
    return (
        sqrt(INTERSECTION_DISTANCE_MM**2 / 2.0)
        + CORNER_SQUARE_THICKNESS_MM
    )


def lite_breakpoints_mm() -> tuple[float, ...]:
    """Return unique Lite-local horizontal edge planes.

    openGridLite() retains the upper 4.0 mm of the 6.8 mm source tile.
    Source profile edges map to Lite-local Z = 1.6, 2.6, 3.6 and 4.0 mm.

    Z=0.0 and Z=1.6 have identical XY geometry, so only Z=1.6 is needed in
    the merged top-view line set.
    """

    lite_source_start_mm = TILE_THICKNESS_MM - LITE_TILE_THICKNESS_MM

    lower_band_top_mm = (
        TILE_THICKNESS_MM
        - TOP_CAPTURE_INITIAL_INSET_MM
        - lite_source_start_mm
    )
    ramp_top_mm = lower_band_top_mm + INSIDE_GRID_MIDDLE_CHAMFER_MM
    capture_top_mm = (
        TILE_THICKNESS_MM
        - INSIDE_GRID_TOP_CHAMFER_MM
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


def side_inset_mm(local_z_mm: float) -> float:
    """Straight-edge material depth at one Lite-local Z plane."""

    inside_mm = inside_extrusion_mm()
    maximum_inset_mm = OUTSIDE_EXTRUSION_MM + inside_mm
    lower_z, ramp_top_z, capture_top_z, top_z = lite_breakpoints_mm()

    if not 0.0 <= local_z_mm <= top_z:
        raise ValueError(
            f"Lite-local Z outside 0..{top_z:g} mm: {local_z_mm}"
        )

    if local_z_mm <= lower_z:
        return OUTSIDE_EXTRUSION_MM

    if local_z_mm <= ramp_top_z:
        fraction = (local_z_mm - lower_z) / (ramp_top_z - lower_z)
        return OUTSIDE_EXTRUSION_MM + fraction * inside_mm

    if local_z_mm <= capture_top_z:
        return maximum_inset_mm

    # Source top chamfer: 1.5 -> 1.1 mm over the final 0.4 mm.
    return maximum_inset_mm - (local_z_mm - capture_top_z)


def corner_extent_mm(local_z_mm: float) -> float:
    """Corner-profile reach before the source 45-degree XY rotation."""

    _, ramp_top_z, _, top_z = lite_breakpoints_mm()

    if not 0.0 <= local_z_mm <= top_z:
        raise ValueError(
            f"Lite-local Z outside 0..{top_z:g} mm: {local_z_mm}"
        )

    offset_mm = corner_offset_mm()

    # The retained source corner stays at full reach through Lite-local Z=2.6,
    # then follows the source 1.4 mm top chamfer to Z=4.0.
    if local_z_mm <= ramp_top_z:
        return offset_mm

    return offset_mm - (local_z_mm - ramp_top_z)


def section_geometry(local_z_mm: float) -> SectionGeometry:
    """Build one exact horizontal XY contour from the source relationships."""

    inset_mm = side_inset_mm(local_z_mm)
    corner_mm = corner_extent_mm(local_z_mm)

    half_mm = TILE_SIZE_MM / 2.0
    inner_flat_mm = half_mm - inset_mm

    # The separate source corner is rotated 45 degrees in XY. Its reach along
    # either tile edge is corner_extent*sqrt(2). The straight side strip
    # overlaps by the current side inset.
    corner_run_mm = corner_mm * sqrt(2.0) - inset_mm
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
        side_inset_mm=inset_mm,
        corner_extent_mm=corner_mm,
    )


def unique_lite_sections() -> tuple[SectionGeometry, ...]:
    """Return the four unique horizontal contours used by the top view."""

    sections = tuple(section_geometry(z_mm) for z_mm in lite_breakpoints_mm())

    # Deliberately omitted duplicate bottom plane.
    bottom = section_geometry(0.0)
    assert bottom.outer == sections[0].outer
    assert bottom.inner == sections[0].inner

    return sections
