// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Stage-1 detachable-interface contract.
//
// This file defines the nominal mating relationship independently of the
// reference receiver/snap implementation. The 10 x 4 mm baseline is the
// currently studied PoP size. Width/height are exposed through functions so a
// later experiment can qualify other sizes without changing the meaning of the
// contract.
//
// The OpenGrid values below are an experiment interpretation of the pinned
// QuackWorks source dimensions. They are not an upstream manufacturing drawing.

// Nominal experiment baseline.
DETACHABLE_INTERFACE_WIDTH = 10.0;
DETACHABLE_INTERFACE_HEIGHT = 4.0;
DETACHABLE_INTERFACE_REFERENCE_LENGTH = 10.0;
DETACHABLE_INTERFACE_END_TRANSITION_LENGTH = 1.0;
DETACHABLE_INTERFACE_ACTIVE_LENGTH =
    DETACHABLE_INTERFACE_REFERENCE_LENGTH
    - 2 * DETACHABLE_INTERFACE_END_TRANSITION_LENGTH;

// Local one-side profile construction copied/derived from the pinned
// openGridTileAp1() and openGridSnap() source. These values are what the first
// profile drawings dimension.
DETACHABLE_SOURCE_TILE_THICKNESS = 6.8;
DETACHABLE_SOURCE_LITE_THICKNESS = 4.0;
DETACHABLE_SOURCE_OUTSIDE_EXTRUSION = 0.8;
DETACHABLE_SOURCE_INSIDE_EXTRUSION = 0.7;
DETACHABLE_SOURCE_TOP_CHAMFER = 0.4;
DETACHABLE_SOURCE_MIDDLE_CHAMFER = 1.0;
DETACHABLE_SOURCE_CAPTURE_INSET = 2.4;

DETACHABLE_SOURCE_SNAP_BODY_CLEARANCE = 0.1; // (25.0 - 24.8) / 2
DETACHABLE_SOURCE_NUB_HEIGHT = 0.2;
DETACHABLE_SOURCE_NUB_DEPTH = 0.4;
DETACHABLE_SOURCE_NUB_TOP_WEDGE_HEIGHT = 0.6;
DETACHABLE_SOURCE_NUB_BOTTOM_WEDGE_HEIGHT = 0.6;

function detachable_side_middle_angle_from_horizontal() =
    atan(
        DETACHABLE_SOURCE_MIDDLE_CHAMFER
        / DETACHABLE_SOURCE_INSIDE_EXTRUSION
    );
function detachable_side_middle_angle_from_vertical() =
    90 - detachable_side_middle_angle_from_horizontal();
function detachable_side_top_angle() = 45.0;
function detachable_nub_wedge_angle_from_horizontal() =
    atan(
        DETACHABLE_SOURCE_NUB_TOP_WEDGE_HEIGHT
        / DETACHABLE_SOURCE_NUB_DEPTH
    );

// Local fixed-side mating surface, with X=0 as the capture-face datum.
// Z=0 is the bottom of the retained Lite interface. This is ONE SIDE only.
function detachable_local_fixed_surface_points(
    height = DETACHABLE_INTERFACE_HEIGHT
) = [
    [-DETACHABLE_SOURCE_INSIDE_EXTRUSION, 0],
    [
        -DETACHABLE_SOURCE_INSIDE_EXTRUSION,
        detachable_interface_lower_z(height)
    ],
    [0, detachable_interface_ramp_top_z(height)],
    [0, detachable_interface_capture_top_z(height)],
    [-DETACHABLE_SOURCE_TOP_CHAMFER, height]
];

// Material polygon for the OpenGrid fixed wall: opening is to the left and
// wall material extends to the right of the local surface.
function detachable_opengrid_fixed_side_material_points(
    backing = 2.2,
    height = DETACHABLE_INTERFACE_HEIGHT
) = concat(
    [[backing, 0]],
    detachable_local_fixed_surface_points(height),
    [[backing, height]]
);

// Material polygon for the node fixed tongue/ridge: carrier material extends
// to the left of the same local surface. This is the radial-role inversion.
function detachable_node_fixed_side_material_points(
    backing = 2.2,
    height = DETACHABLE_INTERFACE_HEIGHT
) = concat(
    [[-backing, 0]],
    detachable_local_fixed_surface_points(height),
    [[-backing, height]]
);

function detachable_nominal_side_clearance() =
    DETACHABLE_SOURCE_SNAP_BODY_CLEARANCE;
function detachable_nominal_nub_overlap() =
    DETACHABLE_SOURCE_NUB_DEPTH - DETACHABLE_SOURCE_SNAP_BODY_CLEARANCE;

// Pinned OpenGrid Lite source dimensions used by the reduction.
DETACHABLE_SOURCE_CAPTURE_WIDTH = 25.0;
DETACHABLE_SOURCE_LOWER_WIDTH = 26.4;
DETACHABLE_SOURCE_TOP_WIDTH = 25.8;
DETACHABLE_SOURCE_SNAP_BODY_WIDTH = 24.8;
DETACHABLE_SOURCE_SNAP_NUB_OUTER_WIDTH = 25.6;

// Vertical bands retained from the Lite fixed-side profile. Express these from
// nominal height so the relationship remains explicit if a later PoP changes
// the baseline height.
function detachable_interface_lower_z(height = DETACHABLE_INTERFACE_HEIGHT) =
    height - 2.4;
function detachable_interface_ramp_top_z(height = DETACHABLE_INTERFACE_HEIGHT) =
    height - 1.4;
function detachable_interface_capture_top_z(height = DETACHABLE_INTERFACE_HEIGHT) =
    height - 0.4;

// Radial mirror around source-capture + target-capture width.
function detachable_interface_mirror_sum(width = DETACHABLE_INTERFACE_WIDTH) =
    DETACHABLE_SOURCE_CAPTURE_WIDTH + width;

function detachable_interface_receiver_width(width = DETACHABLE_INTERFACE_WIDTH) =
    width;
function detachable_interface_receiver_lower_width(width = DETACHABLE_INTERFACE_WIDTH) =
    detachable_interface_mirror_sum(width) - DETACHABLE_SOURCE_LOWER_WIDTH;
function detachable_interface_receiver_top_width(width = DETACHABLE_INTERFACE_WIDTH) =
    detachable_interface_mirror_sum(width) - DETACHABLE_SOURCE_TOP_WIDTH;

function detachable_interface_snap_inner_width(width = DETACHABLE_INTERFACE_WIDTH) =
    detachable_interface_mirror_sum(width) - DETACHABLE_SOURCE_SNAP_BODY_WIDTH;
function detachable_interface_snap_nub_opening(width = DETACHABLE_INTERFACE_WIDTH) =
    detachable_interface_mirror_sum(width)
    - DETACHABLE_SOURCE_SNAP_NUB_OUTER_WIDTH;
function detachable_interface_snap_nub_protrusion(width = DETACHABLE_INTERFACE_WIDTH) =
    (
        detachable_interface_snap_inner_width(width)
        - detachable_interface_snap_nub_opening(width)
    ) / 2;

// The Lite source has a 3.4 mm removable-side engagement against the 4.0 mm
// fixed-side envelope. The 0.6 mm difference is not a seated offset.
function detachable_interface_snap_engagement_height(
    height = DETACHABLE_INTERFACE_HEIGHT
) = height - 0.6;


function detachable_interface_depth_factor(t) =
    max(0.001, 1 - (t * t * (3 - 2 * t)));

function detachable_interface_end_transition_length() =
    DETACHABLE_INTERFACE_END_TRANSITION_LENGTH;

function detachable_interface_active_length() =
    DETACHABLE_INTERFACE_ACTIVE_LENGTH;

function detachable_interface_receiver_profile_points(
    width = DETACHABLE_INTERFACE_WIDTH,
    height = DETACHABLE_INTERFACE_HEIGHT
) = [
    [
        -detachable_interface_receiver_lower_width(width) / 2,
        0
    ],
    [
         detachable_interface_receiver_lower_width(width) / 2,
        0
    ],
    [
         detachable_interface_receiver_lower_width(width) / 2,
        detachable_interface_lower_z(height)
    ],
    [
         detachable_interface_receiver_width(width) / 2,
        detachable_interface_ramp_top_z(height)
    ],
    [
         detachable_interface_receiver_width(width) / 2,
        detachable_interface_capture_top_z(height)
    ],
    [
         detachable_interface_receiver_top_width(width) / 2,
        height
    ],
    [
        -detachable_interface_receiver_top_width(width) / 2,
        height
    ],
    [
        -detachable_interface_receiver_width(width) / 2,
        detachable_interface_capture_top_z(height)
    ],
    [
        -detachable_interface_receiver_width(width) / 2,
        detachable_interface_ramp_top_z(height)
    ],
    [
        -detachable_interface_receiver_lower_width(width) / 2,
        detachable_interface_lower_z(height)
    ]
];

// Source-side fixed-edge profile interpreted from the same pinned dimensions.
// This is useful only for explaining the reduction; it is not an upstream
// released drawing.
function detachable_source_lite_profile_points(
    height = DETACHABLE_INTERFACE_HEIGHT
) = [
    [-DETACHABLE_SOURCE_LOWER_WIDTH / 2, 0],
    [ DETACHABLE_SOURCE_LOWER_WIDTH / 2, 0],
    [
         DETACHABLE_SOURCE_LOWER_WIDTH / 2,
        detachable_interface_lower_z(height)
    ],
    [
         DETACHABLE_SOURCE_CAPTURE_WIDTH / 2,
        detachable_interface_ramp_top_z(height)
    ],
    [
         DETACHABLE_SOURCE_CAPTURE_WIDTH / 2,
        detachable_interface_capture_top_z(height)
    ],
    [ DETACHABLE_SOURCE_TOP_WIDTH / 2, height],
    [-DETACHABLE_SOURCE_TOP_WIDTH / 2, height],
    [
        -DETACHABLE_SOURCE_CAPTURE_WIDTH / 2,
        detachable_interface_capture_top_z(height)
    ],
    [
        -DETACHABLE_SOURCE_CAPTURE_WIDTH / 2,
        detachable_interface_ramp_top_z(height)
    ],
    [
        -DETACHABLE_SOURCE_LOWER_WIDTH / 2,
        detachable_interface_lower_z(height)
    ]
];

assert(abs(detachable_interface_receiver_width() - 10.0) < 0.0001);
assert(abs(detachable_interface_receiver_lower_width() - 8.6) < 0.0001);
assert(abs(detachable_interface_receiver_top_width() - 9.2) < 0.0001);
assert(abs(detachable_interface_snap_inner_width() - 10.2) < 0.0001);
assert(abs(detachable_interface_snap_nub_opening() - 9.4) < 0.0001);
assert(abs(detachable_interface_snap_nub_protrusion() - 0.4) < 0.0001);
assert(abs(detachable_interface_snap_engagement_height() - 3.4) < 0.0001);


// Local-profile invariants used by specification drawings.
assert(abs(detachable_side_middle_angle_from_horizontal() - 55.0079798) < 0.001);
assert(abs(detachable_side_middle_angle_from_vertical() - 34.9920202) < 0.001);
assert(abs(detachable_side_top_angle() - 45.0) < 0.0001);
assert(abs(detachable_nub_wedge_angle_from_horizontal() - 56.3099325) < 0.001);
assert(abs(detachable_nominal_side_clearance() - 0.1) < 0.0001);
assert(abs(detachable_nominal_nub_overlap() - 0.3) < 0.0001);

assert(abs(DETACHABLE_INTERFACE_REFERENCE_LENGTH - 10.0) < 0.0001);
assert(abs(DETACHABLE_INTERFACE_END_TRANSITION_LENGTH - 1.0) < 0.0001);
assert(abs(DETACHABLE_INTERFACE_ACTIVE_LENGTH - 8.0) < 0.0001);
