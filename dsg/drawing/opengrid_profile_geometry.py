"""OpenGrid Lite plan/profile geometry in real millimetres.

This module contains source dimensions and deterministic 2D geometry only.
It deliberately has no drawsvg, SVG/XML, Inkscape or OpenSCAD process logic.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import isclose, sqrt


Point = tuple[float, float]
Segment = tuple[Point, Point]
Polygon = tuple[Point, ...]
SegmentLayer = tuple[Segment, ...]


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

_GEOMETRY_EPSILON_MM = 1e-9


@dataclass(frozen=True)
class SectionGeometry:
    """One horizontal OpenGrid Lite section in XY model coordinates."""

    local_z_mm: float
    outer: Polygon
    inner: Polygon
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
    """Return the unique Lite-local horizontal edge planes.

    openGridLite() retains the upper 4.0 mm of the 6.8 mm source tile.
    Source profile edges map to Lite-local Z = 1.6, 2.6, 3.6 and 4.0 mm.

    Z=0.0 and Z=1.6 have identical XY geometry, so only Z=1.6 is needed in
    the merged top-view edge set.
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

    outer: Polygon = (
        (-half_mm, -half_mm),
        (half_mm, -half_mm),
        (half_mm, half_mm),
        (-half_mm, half_mm),
    )
    inner: Polygon = (
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
    """Return the four unique horizontal sections used by the top view."""

    sections = tuple(
        section_geometry(z_mm)
        for z_mm in lite_breakpoints_mm()
    )

    # Deliberately omitted duplicate bottom plane.
    bottom = section_geometry(0.0)
    assert bottom.outer == sections[0].outer
    assert bottom.inner == sections[0].inner

    return sections


def polygon_signed_area(polygon: Polygon) -> float:
    """Signed polygon area; positive means counter-clockwise."""

    return 0.5 * sum(
        polygon[index][0] * polygon[(index + 1) % len(polygon)][1]
        - polygon[(index + 1) % len(polygon)][0] * polygon[index][1]
        for index in range(len(polygon))
    )


def visible_contour_layers(
    inner_polygons_bottom_to_top: tuple[Polygon, ...],
) -> tuple[SegmentLayer, ...]:
    """Return top-visible edge segments for horizontal opening contours.

    Each source section describes material outside its inner opening. A lower
    edge is visible from +Z only where its XY position lies strictly inside
    every higher opening. Therefore each lower contour edge is clipped against
    all higher inner polygons; a segment coincident with a higher boundary is
    hidden by that higher edge.

    This is the geometric equivalent of stacking the horizontal section
    drawings while removing lines hidden by material or edges above them.
    """

    polygons = tuple(
        _counter_clockwise(polygon)
        for polygon in inner_polygons_bottom_to_top
    )

    layers: list[SegmentLayer] = []

    for index, polygon in enumerate(polygons):
        higher_openings = polygons[index + 1 :]
        visible_segments: list[Segment] = []

        for point_index, start in enumerate(polygon):
            end = polygon[(point_index + 1) % len(polygon)]
            segment: Segment | None = (start, end)

            for opening in higher_openings:
                if segment is None:
                    break

                segment = _clip_segment_inside_convex_polygon(
                    segment,
                    opening,
                )

                if (
                    segment is not None
                    and not _segment_midpoint_strictly_inside_polygon(
                        segment,
                        opening,
                    )
                ):
                    # A lower edge that projects exactly onto a higher edge is
                    # hidden by that higher edge in the top view.
                    segment = None

            if (
                segment is not None
                and _segment_length_squared(segment)
                > _GEOMETRY_EPSILON_MM**2
            ):
                visible_segments.append(segment)

        layers.append(tuple(visible_segments))

    return tuple(layers)


def segment_endpoints(
    layers: tuple[SegmentLayer, ...],
) -> tuple[Point, ...]:
    """Flatten visible segment endpoints for numerical comparison."""

    return tuple(
        point
        for layer in layers
        for segment in layer
        for point in segment
    )


def maximum_point_set_delta_mm(
    expected: tuple[Point, ...] | list[Point],
    reference: tuple[Point, ...] | list[Point],
) -> float:
    """Symmetric maximum nearest-point distance between two point sets."""

    expected_unique = _unique_points(expected)
    reference_unique = _unique_points(reference)

    if len(reference_unique) != len(expected_unique):
        raise RuntimeError(
            "geometry point-count mismatch: "
            f"expected={len(expected_unique)}, "
            f"reference={len(reference_unique)}"
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


def _counter_clockwise(polygon: Polygon) -> Polygon:
    if polygon_signed_area(polygon) >= 0:
        return polygon
    return tuple(reversed(polygon))


def _clip_segment_inside_convex_polygon(
    segment: Segment,
    polygon: Polygon,
) -> Segment | None:
    """Clip a segment to the inside of one counter-clockwise convex polygon."""

    start, end = segment
    delta_x = end[0] - start[0]
    delta_y = end[1] - start[1]

    lower_t = 0.0
    upper_t = 1.0

    for index, edge_start in enumerate(polygon):
        edge_end = polygon[(index + 1) % len(polygon)]
        edge_x = edge_end[0] - edge_start[0]
        edge_y = edge_end[1] - edge_start[1]

        # Inside a CCW polygon is the left side of every oriented edge.
        start_side = (
            edge_x * (start[1] - edge_start[1])
            - edge_y * (start[0] - edge_start[0])
        )
        delta_side = edge_x * delta_y - edge_y * delta_x

        if abs(delta_side) <= _GEOMETRY_EPSILON_MM:
            if start_side < -_GEOMETRY_EPSILON_MM:
                return None
            continue

        crossing_t = -start_side / delta_side

        if delta_side > 0:
            lower_t = max(lower_t, crossing_t)
        else:
            upper_t = min(upper_t, crossing_t)

        if lower_t > upper_t + _GEOMETRY_EPSILON_MM:
            return None

    return (
        (
            start[0] + lower_t * delta_x,
            start[1] + lower_t * delta_y,
        ),
        (
            start[0] + upper_t * delta_x,
            start[1] + upper_t * delta_y,
        ),
    )


def _segment_midpoint_strictly_inside_polygon(
    segment: Segment,
    polygon: Polygon,
) -> bool:
    start, end = segment
    midpoint = (
        (start[0] + end[0]) / 2.0,
        (start[1] + end[1]) / 2.0,
    )

    for index, edge_start in enumerate(polygon):
        edge_end = polygon[(index + 1) % len(polygon)]
        edge_x = edge_end[0] - edge_start[0]
        edge_y = edge_end[1] - edge_start[1]

        side = (
            edge_x * (midpoint[1] - edge_start[1])
            - edge_y * (midpoint[0] - edge_start[0])
        )

        if side <= _GEOMETRY_EPSILON_MM:
            return False

    return True


def _segment_length_squared(segment: Segment) -> float:
    start, end = segment
    delta_x = end[0] - start[0]
    delta_y = end[1] - start[1]
    return delta_x * delta_x + delta_y * delta_y


def _unique_points(points: tuple[Point, ...] | list[Point]) -> list[Point]:
    unique: list[Point] = []

    for point in points:
        if not any(
            _point_distance_mm(point, existing)
            <= _GEOMETRY_EPSILON_MM
            for existing in unique
        ):
            unique.append(point)

    return unique


def _point_distance_mm(left: Point, right: Point) -> float:
    delta_x = left[0] - right[0]
    delta_y = left[1] - right[1]
    return sqrt(delta_x * delta_x + delta_y * delta_y)
