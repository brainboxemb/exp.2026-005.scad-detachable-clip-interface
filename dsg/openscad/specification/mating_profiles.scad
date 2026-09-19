// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// First-principles one-side mating profile study.
//
// These sheets deliberately avoid the complete symmetric 10 mm cross-section.
// The contract is local: one fixed-side wall/tongue profile and the matching
// removable nub/groove profile.

include <../lib/detachable_interface_spec.scad>
include <../lib/node_interface.scad>
use <../lib/technical_drawing.scad>
use <../design_support.scad>
use <../components/opengrid-lite-snap/opengrid_lite_snap.scad>

PROFILE_BACKING = 2.2;

// Exact pinned-source normal nub, reduced to an X/Z centre section and moved
// into local source coordinates:
//   X=0 = snap body face
//   Z=0 = bottom of the source nub construction
module _opengrid_nub_profile_2d() {
    translate([
        -(_og_lite_snap_w() / 2 - 0.01),
        _og_lite_snap_h() / 2
    ])
        projection(cut = false)
            rotate([-90, 0, 0])
                intersection() {
                    opengrid_lite_snap_design_one_nub_final();
                    translate([-20, -0.03, -5])
                        cube([40, 0.06, 10]);
                }
}

// The node keeps the source radial/Z nub construction and mirrors its radial
// direction. Tangential Y scaling therefore does not alter this X/Z section.
module _node_nub_profile_2d() {
    mirror([1, 0, 0])
        projection(cut = false)
            rotate([-90, 0, 0])
                intersection() {
                    _node_source_nub_local();
                    translate([-2, -0.03, -1])
                        cube([4, 0.06, 5]);
                }
}

module _opengrid_fixed_profile() {
    td_outline()
        polygon(
            detachable_opengrid_fixed_side_material_points(PROFILE_BACKING)
        );
}

module _node_fixed_profile() {
    td_outline()
        polygon(
            detachable_node_fixed_side_material_points(PROFILE_BACKING)
        );
}

module _fixed_profile_dimensions(material_side = "right") {
    // Retained local envelope.
    td_dimension_v(
        0,
        DETACHABLE_INTERFACE_HEIGHT,
        material_side == "right" ? -3.0 : 3.0,
        0
    );

    // Radial lower relief: 0.7 mm.
    td_dimension_h(
        -DETACHABLE_SOURCE_INSIDE_EXTRUSION,
        0,
        -0.75,
        0
    );

    // Main 1.0 mm vertical ramp and 1.0 mm capture face.
    td_dimension_v(
        detachable_interface_lower_z(),
        detachable_interface_ramp_top_z(),
        material_side == "right" ? -1.5 : 1.5,
        0
    );
    td_dimension_v(
        detachable_interface_ramp_top_z(),
        detachable_interface_capture_top_z(),
        material_side == "right" ? -1.25 : 1.25,
        0
    );

    // Top 0.4 x 0.4 chamfer.
    td_dimension_h(
        -DETACHABLE_SOURCE_TOP_CHAMFER,
        0,
        4.65,
        DETACHABLE_INTERFACE_HEIGHT
    );
    td_dimension_v(
        detachable_interface_capture_top_z(),
        DETACHABLE_INTERFACE_HEIGHT,
        material_side == "right" ? -1.05 : 1.05,
        0
    );

    td_angle(
        [-DETACHABLE_SOURCE_INSIDE_EXTRUSION, detachable_interface_lower_z()],
        0,
        detachable_side_middle_angle_from_horizontal(),
        0.55,
        0,
        0.25
    );
    td_angle(
        [-DETACHABLE_SOURCE_TOP_CHAMFER, DETACHABLE_INTERFACE_HEIGHT],
        -45,
        45,
        0.45,
        0,
        0.22
    );
}

module _nub_dimensions(direction = 1) {
    // Body-face datum and 0.4 mm source nub depth.
    td_dimension_h(
        0,
        direction * DETACHABLE_SOURCE_NUB_DEPTH,
        -0.70,
        DETACHABLE_SOURCE_NUB_HEIGHT
    );

    // Source construction heights.
    td_dimension_v(
        0,
        DETACHABLE_SOURCE_NUB_HEIGHT,
        direction * 0.95,
        0
    );
    td_dimension_v(
        DETACHABLE_SOURCE_NUB_HEIGHT,
        DETACHABLE_SOURCE_NUB_HEIGHT
            + DETACHABLE_SOURCE_NUB_BOTTOM_WEDGE_HEIGHT,
        direction * 1.20,
        0
    );

    translate([direction * 0.55, 1.30])
        text(
            str(
                round(detachable_nub_wedge_angle_from_horizontal() * 10) / 10,
                " deg"
            ),
            size = 0.30,
            halign = direction > 0 ? "left" : "right"
        );
}

module opengrid_mating_profile_sheet() {
    design_bosl2_context()
        td_frame(
            "OPENGRID LITE - LOCAL MATING PROFILE",
            "experiment reconstruction from pinned QuackWorks source; not an upstream drawing",
            "15:1"
        ) {
            // Fixed opening wall.
            translate([47, 42])
                scale([15, 15]) {
                    _opengrid_fixed_profile();
                    _fixed_profile_dimensions("right");
                }

            // Matching removable snap nub. Body face is drawn as a datum.
            translate([129, 42])
                scale([15, 15]) {
                    td_line_v(0, -0.15, 2.25, 0.025);
                    td_outline(0.045)
                        _opengrid_nub_profile_2d();
                    _nub_dimensions(1);
                }

            translate([20, 105])
                text("A  FIXED OPENING WALL", size = 3.2);
            translate([20, 99])
                text("one local side of the Lite opening", size = 2.5);

            translate([106, 105])
                text("B  REMOVABLE SNAP NUB", size = 3.2);
            translate([106, 99])
                text("matching normal nub at one side", size = 2.5);

            translate([12, 24])
                text("Key fixed-side construction: 0.7 radial x 1.0 vertical ramp = 55.0 deg; top chamfer = 45 deg.", size = 2.35);
            translate([12, 20])
                text("Snap body nominal side clearance = 0.1 mm; nub depth = 0.4 mm; nominal capture overlap = 0.3 mm.", size = 2.35);
        }
}

module node_mating_profile_sheet() {
    design_bosl2_context()
        td_frame(
            "NODE - LOCAL TONGUE / GROOVE PROFILE",
            "radial-role inversion of the pinned Lite relationship; one mating side only",
            "15:1"
        ) {
            // Fixed node tongue/ridge.
            translate([47, 42])
                scale([15, 15]) {
                    _node_fixed_profile();
                    _fixed_profile_dimensions("left");
                }

            // Matching inward snap nub/groove wall. Put the nominal inner wall
            // 0.1 mm outside the fixed capture datum, then project the nub
            // inward by 0.4 mm.
            translate([129, 42])
                scale([15, 15]) {
                    translate([DETACHABLE_SOURCE_SNAP_BODY_CLEARANCE, 0]) {
                        td_line_v(0, -0.15, 2.25, 0.025);
                        td_outline(0.045)
                            _node_nub_profile_2d();
                    }
                    translate([DETACHABLE_SOURCE_SNAP_BODY_CLEARANCE, 0])
                        _nub_dimensions(-1);
                }

            translate([20, 105])
                text("A  FIXED TONGUE / RIDGE", size = 3.2);
            translate([20, 99])
                text("local node receiver side profile", size = 2.5);

            translate([106, 105])
                text("B  REMOVABLE GROOVE / LATCH", size = 3.2);
            translate([106, 99])
                text("local node snap inner face + inward nub", size = 2.5);

            translate([12, 24])
                text("The 10 mm node width is the spacing between two mirrored local sides; it is not the local profile itself.", size = 2.35);
            translate([12, 20])
                text("The fixed profile retains the 0.7 x 1.0 ramp and 0.4 x 0.4 top chamfer; the snap mirrors the 0.4 mm nub inward.", size = 2.35);
        }
}

module mating_profile_design(view = "opengrid") {
    if (view == "opengrid")
        opengrid_mating_profile_sheet();
    else if (view == "node")
        node_mating_profile_sheet();
    else
        assert(false, str("unknown mating-profile view: ", view));
}
