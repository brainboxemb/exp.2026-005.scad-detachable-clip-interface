// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Thin design-object wrapper around the pinned QuackWorks/OpenGrid Lite snap.
// See LICENSE and docs/00-source-provenance.md.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/opengrid_reference.scad>

module reference_lite_snap_build() {
    opengrid_lite_snap();
}

module reference_lite_snap_profile(flex_slot_plane = false) {
    if (flex_slot_plane)
        opengrid_lite_snap_profile();
    else
        opengrid_lite_snap_solid_profile();
}



// Design-analysis view: color the exact final Lite snap by the two principal
// source construction layers. The source is CENTER anchored at h=3.4, so
// local 0..3.0 core maps to global -1.7..+1.3 and the 0.4 top maps to +1.3..+1.7.

module _reference_lite_snap_z_band(z0, z1) {
    intersection() {
        reference_lite_snap_build();
        translate([-30, -30, z0])
            cube([60, 60, z1 - z0]);
    }
}

module reference_lite_snap_design_source_layers() {
    color([0.58, 0.58, 0.58, 1.0])
        _reference_lite_snap_z_band(-1.7, 1.3);
    color([0.88, 0.08, 0.06, 1.0])
        _reference_lite_snap_z_band(1.3, 1.7);
}

// Standalone opening shows the primary reference object.
reference_lite_snap_build();
