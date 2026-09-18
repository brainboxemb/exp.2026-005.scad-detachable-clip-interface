// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Thin design-object wrapper around the pinned QuackWorks/OpenGrid Lite snap.
// See LICENSE and docs/00-source-provenance.md.

$fn = 120;

use <../../lib/og02_full_lite_reference.scad>

module reference_lite_snap_build() {
    og02_lite_snap();
}

module reference_lite_snap_profile(flex_slot_plane = false) {
    if (flex_slot_plane)
        og02_lite_snap_profile();
    else
        og02_lite_snap_solid_profile();
}

// Standalone opening shows the primary reference object.
reference_lite_snap_build();
