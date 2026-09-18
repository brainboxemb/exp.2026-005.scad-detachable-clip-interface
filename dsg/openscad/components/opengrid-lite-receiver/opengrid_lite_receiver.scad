// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Thin design-object wrapper around the pinned QuackWorks/OpenGrid Lite
// receiver. See LICENSE and docs/00-source-provenance.md.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/opengrid_reference.scad>
use <../../ext/quackworks/openGrid/openGrid.scad>

module opengrid_lite_receiver_build() {
    opengrid_lite_receiver();
}

module opengrid_lite_receiver_profile_view(flex_slot_plane = false) {
    if (flex_slot_plane)
        opengrid_lite_receiver_profile();
    else
        opengrid_lite_receiver_solid_profile();
}



// Design reconstruction of the upstream Lite extraction.
// The Full source cell is 6.8 mm high and the Lite receiver keeps its upper
// 4.0 mm before the result is re-centered around Z=0.

module opengrid_lite_receiver_design_full_source() {
    openGrid(
        Board_Width = 1,
        Board_Height = 1,
        anchor = CENTER
    );
}

module opengrid_lite_receiver_design_retained_top_raw() {
    intersection() {
        opengrid_lite_receiver_design_full_source();

        // Full cell spans Z=-3.4..+3.4. Keeping the upper 4.0 mm therefore
        // means Z=-0.6..+3.4 before the Lite result is re-centered.
        translate([-20, -20, -0.6])
            cube([40, 40, 4.0]);
    }
}

module opengrid_lite_receiver_design_full_with_retained_top() {
    color([0.56, 0.56, 0.56, 0.28])
        opengrid_lite_receiver_design_full_source();

    color([0.88, 0.08, 0.06, 0.88])
        opengrid_lite_receiver_design_retained_top_raw();
}

module opengrid_lite_receiver_design_retained_top_only() {
    opengrid_lite_receiver_design_retained_top_raw();
}

module opengrid_lite_receiver_design_recentered_extraction() {
    // Raw retained region spans Z=-0.6..+3.4, so its centre is +1.4 mm.
    // Move it down by that amount to expose the recentering step explicitly.
    translate([0, 0, -1.4])
        opengrid_lite_receiver_design_retained_top_raw();
}

module opengrid_lite_receiver_design_recentered_compare() {
    translate([-16, 0, 0])
        opengrid_lite_receiver_design_recentered_extraction();

    translate([16, 0, 0])
        opengrid_lite_receiver_build();
}

module opengrid_lite_receiver_design_recentered_result() {
    // Use the exact upstream Lite module for the final state. The preceding
    // views explain the extraction that openGridLite performs internally.
    opengrid_lite_receiver_build();
}

// Design-analysis view: split the exact solid receiver profile into the four
// Lite Z zones used by the experiment's radial-mirror derivation.
// openGridLite is CENTER anchored, so local Lite Z=0..4 maps to global -2..+2.

module _opengrid_lite_receiver_profile_band(z0, z1) {
    intersection() {
        opengrid_lite_receiver_profile_view(false);
        translate([-40, -10, z0])
            cube([80, 20, z1 - z0]);
    }
}

module opengrid_lite_receiver_design_profile_zones() {
    color([0.58, 0.58, 0.58, 1.0])
        _opengrid_lite_receiver_profile_band(-2.0, -0.4); // local 0.0..1.6
    color([0.76, 0.30, 0.12, 1.0])
        _opengrid_lite_receiver_profile_band(-0.4, 0.6);  // local 1.6..2.6
    color([0.72, 0.72, 0.72, 1.0])
        _opengrid_lite_receiver_profile_band(0.6, 1.6);   // local 2.6..3.6
    color([0.88, 0.08, 0.06, 1.0])
        _opengrid_lite_receiver_profile_band(1.6, 2.0);   // local 3.6..4.0
}

// Standalone opening shows the primary OpenGrid source object.
opengrid_lite_receiver_build();
