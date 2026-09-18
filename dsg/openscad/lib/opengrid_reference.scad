// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Experiment wrapper around the pinned QuackWorks/OpenGrid reference.
// Original OpenGrid design: David D.
// QuackWorks/OpenSCAD reference: AndyLevesque/QuackWorks,
// pinned at e0c1cb7ec78dd9e9a8476ed739bd3402074354f3.
// Third-party source retains its own notices; see LICENSE and
// docs/00-source-provenance.md.
//
// File: opengrid_reference.scad
// Full versus Lite QuackWorks OpenGrid reference comparison.
//
// Keep upstream defaults intact wherever possible. The only variant selector
// supplied to the Lite snap is lite=true. The upstream file itself invokes
// openGridSnap() without orient/anchor/spin, so this reference does the same.
//
// "center" profiles pass through the retention/flex slots. "solid" profiles use
// an offset Y plane beside those slots to expose the continuous body. All profile
// modules are true 1.0 mm-thick slices and remain valid 3D solids for STL export.

include <BOSL2/std.scad>
use <../ext/quackworks/openGrid/openGrid.scad>
use <../ext/quackworks/openGrid/opengrid-snap.scad>

OPENGRID_REFERENCE_COMPARE_X = 19;
OPENGRID_REFERENCE_EXPLODED_Z = 14;
OPENGRID_REFERENCE_PROFILE_SLICE_Y = 1.0;
OPENGRID_REFERENCE_PROFILE_SOLID_Y = 7.0;

module opengrid_full_receiver() {
    openGrid(
        Board_Width = 1,
        Board_Height = 1
    );
}

module opengrid_lite_receiver() {
    openGridLite(
        Board_Width = 1,
        Board_Height = 1
    );
}

module opengrid_full_snap() {
    openGridSnap();
}

module opengrid_lite_snap() {
    openGridSnap(
        lite = true
    );
}

module _opengrid_profile_slice_volume(y = 0) {
    translate([-40, y - OPENGRID_REFERENCE_PROFILE_SLICE_Y / 2, -20])
        cube([80, OPENGRID_REFERENCE_PROFILE_SLICE_Y, 40]);
}

module _opengrid_profile_slice(y = 0) {
    intersection() {
        children();
        _opengrid_profile_slice_volume(y);
    }
}

module opengrid_full_receiver_profile() {
    _opengrid_profile_slice()
        opengrid_full_receiver();
}

module opengrid_full_snap_profile() {
    _opengrid_profile_slice()
        opengrid_full_snap();
}

module opengrid_lite_receiver_profile() {
    _opengrid_profile_slice()
        opengrid_lite_receiver();
}

module opengrid_lite_snap_profile() {
    _opengrid_profile_slice()
        opengrid_lite_snap();
}

module opengrid_full_receiver_solid_profile() {
    _opengrid_profile_slice(OPENGRID_REFERENCE_PROFILE_SOLID_Y)
        opengrid_full_receiver();
}

module opengrid_full_snap_solid_profile() {
    _opengrid_profile_slice(OPENGRID_REFERENCE_PROFILE_SOLID_Y)
        opengrid_full_snap();
}

module opengrid_lite_receiver_solid_profile() {
    _opengrid_profile_slice(OPENGRID_REFERENCE_PROFILE_SOLID_Y)
        opengrid_lite_receiver();
}

module opengrid_lite_snap_solid_profile() {
    _opengrid_profile_slice(OPENGRID_REFERENCE_PROFILE_SOLID_Y)
        opengrid_lite_snap();
}

module opengrid_full_assembled(receiver_alpha = 0.48) {
    color([0.70, 0.72, 0.76, receiver_alpha])
        opengrid_full_receiver();

    color([0.90, 0.28, 0.14])
        opengrid_full_snap();
}

module opengrid_lite_assembled(receiver_alpha = 0.48) {
    color([0.70, 0.72, 0.76, receiver_alpha])
        opengrid_lite_receiver();

    color([0.90, 0.28, 0.14])
        opengrid_lite_snap();
}

module opengrid_comparison_assembled() {
    translate([-OPENGRID_REFERENCE_COMPARE_X, 0, 0])
        opengrid_full_assembled();

    translate([OPENGRID_REFERENCE_COMPARE_X, 0, 0])
        opengrid_lite_assembled();
}

module opengrid_comparison_exploded() {
    translate([-OPENGRID_REFERENCE_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            opengrid_full_receiver();

        translate([0, 0, OPENGRID_REFERENCE_EXPLODED_Z])
            color([0.90, 0.28, 0.14])
                opengrid_full_snap();
    }

    translate([OPENGRID_REFERENCE_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            opengrid_lite_receiver();

        translate([0, 0, OPENGRID_REFERENCE_EXPLODED_Z])
            color([0.90, 0.28, 0.14])
                opengrid_lite_snap();
    }
}

// Primary comparison section: cut beside the flex/click slots so the
// continuous receiver/snap body gives an honest first impression of fit.
module opengrid_comparison_section() {
    translate([-OPENGRID_REFERENCE_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            opengrid_full_receiver_solid_profile();

        color([0.90, 0.28, 0.14])
            opengrid_full_snap_solid_profile();
    }

    translate([OPENGRID_REFERENCE_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            opengrid_lite_receiver_solid_profile();

        color([0.90, 0.28, 0.14])
            opengrid_lite_snap_solid_profile();
    }
}

// Technical comparison: deliberately cuts through the long flex/click slots.
// Keep separate so missing slot material is not mistaken for general clearance.
module opengrid_comparison_flex_section() {
    translate([-OPENGRID_REFERENCE_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            opengrid_full_receiver_profile();

        color([0.90, 0.28, 0.14])
            opengrid_full_snap_profile();
    }

    translate([OPENGRID_REFERENCE_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            opengrid_lite_receiver_profile();

        color([0.90, 0.28, 0.14])
            opengrid_lite_snap_profile();
    }
}
