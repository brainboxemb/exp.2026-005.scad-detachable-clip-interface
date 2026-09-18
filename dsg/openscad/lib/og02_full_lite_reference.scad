// File: og02_full_lite_reference.scad
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

OG02_COMPARE_X = 19;
OG02_EXPLODED_Z = 14;
OG02_PROFILE_SLICE_Y = 1.0;
OG02_PROFILE_SOLID_Y = 7.0;

module og02_full_receiver() {
    openGrid(
        Board_Width = 1,
        Board_Height = 1
    );
}

module og02_lite_receiver() {
    openGridLite(
        Board_Width = 1,
        Board_Height = 1
    );
}

module og02_full_snap() {
    openGridSnap();
}

module og02_lite_snap() {
    openGridSnap(
        lite = true
    );
}

module _og02_profile_slice_volume(y = 0) {
    translate([-40, y - OG02_PROFILE_SLICE_Y / 2, -20])
        cube([80, OG02_PROFILE_SLICE_Y, 40]);
}

module _og02_profile_slice(y = 0) {
    intersection() {
        children();
        _og02_profile_slice_volume(y);
    }
}

module og02_full_receiver_profile() {
    _og02_profile_slice()
        og02_full_receiver();
}

module og02_full_snap_profile() {
    _og02_profile_slice()
        og02_full_snap();
}

module og02_lite_receiver_profile() {
    _og02_profile_slice()
        og02_lite_receiver();
}

module og02_lite_snap_profile() {
    _og02_profile_slice()
        og02_lite_snap();
}

module og02_full_receiver_solid_profile() {
    _og02_profile_slice(OG02_PROFILE_SOLID_Y)
        og02_full_receiver();
}

module og02_full_snap_solid_profile() {
    _og02_profile_slice(OG02_PROFILE_SOLID_Y)
        og02_full_snap();
}

module og02_lite_receiver_solid_profile() {
    _og02_profile_slice(OG02_PROFILE_SOLID_Y)
        og02_lite_receiver();
}

module og02_lite_snap_solid_profile() {
    _og02_profile_slice(OG02_PROFILE_SOLID_Y)
        og02_lite_snap();
}

module og02_full_assembled(receiver_alpha = 0.48) {
    color([0.70, 0.72, 0.76, receiver_alpha])
        og02_full_receiver();

    color([0.90, 0.28, 0.14])
        og02_full_snap();
}

module og02_lite_assembled(receiver_alpha = 0.48) {
    color([0.70, 0.72, 0.76, receiver_alpha])
        og02_lite_receiver();

    color([0.90, 0.28, 0.14])
        og02_lite_snap();
}

module og02_comparison_assembled() {
    translate([-OG02_COMPARE_X, 0, 0])
        og02_full_assembled();

    translate([OG02_COMPARE_X, 0, 0])
        og02_lite_assembled();
}

module og02_comparison_exploded() {
    translate([-OG02_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            og02_full_receiver();

        translate([0, 0, OG02_EXPLODED_Z])
            color([0.90, 0.28, 0.14])
                og02_full_snap();
    }

    translate([OG02_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            og02_lite_receiver();

        translate([0, 0, OG02_EXPLODED_Z])
            color([0.90, 0.28, 0.14])
                og02_lite_snap();
    }
}

// Primary comparison section: cut beside the flex/click slots so the
// continuous receiver/snap body gives an honest first impression of fit.
module og02_comparison_section() {
    translate([-OG02_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            og02_full_receiver_solid_profile();

        color([0.90, 0.28, 0.14])
            og02_full_snap_solid_profile();
    }

    translate([OG02_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            og02_lite_receiver_solid_profile();

        color([0.90, 0.28, 0.14])
            og02_lite_snap_solid_profile();
    }
}

// Technical comparison: deliberately cuts through the long flex/click slots.
// Keep separate so missing slot material is not mistaken for general clearance.
module og02_comparison_flex_section() {
    translate([-OG02_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            og02_full_receiver_profile();

        color([0.90, 0.28, 0.14])
            og02_full_snap_profile();
    }

    translate([OG02_COMPARE_X, 0, 0]) {
        color([0.70, 0.72, 0.76])
            og02_lite_receiver_profile();

        color([0.90, 0.28, 0.14])
            og02_lite_snap_profile();
    }
}
