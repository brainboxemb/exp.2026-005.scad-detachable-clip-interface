// File: og02_full_lite_reference.scad
// Full versus Lite QuackWorks OpenGrid reference comparison.
//
// Keep upstream defaults intact wherever possible. The only variant selector
// supplied to the Lite snap is lite=true. openGridSnap() still needs its three
// BOSL2 placement arguments because upstream provides no defaults for them.
//
// Individual "profile" modules are true 1.0 mm-thick central Y slices, so they
// remain valid 3D solids for STL export while exposing the X-Z cross-section.

include <BOSL2/std.scad>
use <../ext/quackworks/openGrid/openGrid.scad>
use <../ext/quackworks/openGrid/opengrid-snap.scad>

OG02_COMPARE_X = 19;
OG02_EXPLODED_Z = 14;
OG02_PROFILE_SLICE_Y = 1.0;

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
    openGridSnap(
        orient = UP,
        anchor = CENTER,
        spin = 0
    );
}

module og02_lite_snap() {
    openGridSnap(
        lite = true,
        orient = UP,
        anchor = CENTER,
        spin = 0
    );
}

module _og02_profile_slice_volume() {
    translate([-40, -OG02_PROFILE_SLICE_Y / 2, -20])
        cube([80, OG02_PROFILE_SLICE_Y, 40]);
}

module _og02_profile_slice() {
    intersection() {
        children();
        _og02_profile_slice_volume();
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

module og02_comparison_section() {
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
