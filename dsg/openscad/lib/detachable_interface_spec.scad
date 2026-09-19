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
