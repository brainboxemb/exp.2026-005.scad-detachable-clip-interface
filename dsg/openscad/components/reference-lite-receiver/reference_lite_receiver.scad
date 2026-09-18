// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Thin design-object wrapper around the pinned QuackWorks/OpenGrid Lite
// receiver. See LICENSE and docs/00-source-provenance.md.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/og02_full_lite_reference.scad>

module reference_lite_receiver_build() {
    og02_lite_receiver();
}

module reference_lite_receiver_profile(flex_slot_plane = false) {
    if (flex_slot_plane)
        og02_lite_receiver_profile();
    else
        og02_lite_receiver_solid_profile();
}



// Design-analysis view: split the exact solid receiver profile into the four
// Lite Z zones used by the experiment's radial-mirror derivation.
// openGridLite is CENTER anchored, so local Lite Z=0..4 maps to global -2..+2.

module _reference_lite_receiver_profile_band(z0, z1) {
    intersection() {
        reference_lite_receiver_profile(false);
        translate([-40, -10, z0])
            cube([80, 20, z1 - z0]);
    }
}

module reference_lite_receiver_design_profile_zones() {
    color([0.58, 0.58, 0.58, 1.0])
        _reference_lite_receiver_profile_band(-2.0, -0.4); // local 0.0..1.6
    color([0.76, 0.30, 0.12, 1.0])
        _reference_lite_receiver_profile_band(-0.4, 0.6);  // local 1.6..2.6
    color([0.72, 0.72, 0.72, 1.0])
        _reference_lite_receiver_profile_band(0.6, 1.6);   // local 2.6..3.6
    color([0.88, 0.08, 0.06, 1.0])
        _reference_lite_receiver_profile_band(1.6, 2.0);   // local 3.6..4.0
}

// Standalone opening shows the primary reference object.
reference_lite_receiver_build();
