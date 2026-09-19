// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// A4 fixed-side profile drawings.
//
// Each sheet deliberately contains orthogonal descriptions of the geometry.
// The OpenGrid sheet uses one small orientation view, one primary transverse
// section and one enlarged local detail. This keeps the sheet readable while
// still exposing the source geometry that matters to the reduction.
//
// A single extruded X/Z profile is not a complete interface specification.

include <../lib/detachable_interface_spec.scad>
include <../lib/node_interface.scad>
use <../lib/technical_drawing.scad>
use <../design_support.scad>
use <../lib/opengrid_reference.scad>

module _drawing_outline(width = 0.045) {
    td_outline(width)
        children();
}

module _opengrid_plan_slice_2d() {
    // Exact pinned source, sliced near the top capture surface.
    projection(cut = false)
        intersection() {
            opengrid_lite_receiver();
            // Local Lite Z=0.8 maps to centered source Z=-1.2.
            // This lower constant-width band makes the edge/corner path clear.
            translate([-20, -20, -1.22])
                cube([40, 40, 0.04]);
        }
}

module _opengrid_section_2d() {
    projection(cut = false)
        rotate([-90, 0, 0])
            opengrid_lite_receiver_solid_profile();
}

module _opengrid_section_right_detail_2d() {
    // Keep this as a crop of the exact source section rather than redrawing the
    // profile from nominal dimensions. The dimensions added around it explain
    // the local construction.
    capture_x = DETACHABLE_SOURCE_CAPTURE_WIDTH / 2;
    lite_half_h = DETACHABLE_SOURCE_LITE_THICKNESS / 2;

    intersection() {
        _opengrid_section_2d();
        translate([capture_x - 1.0, -lite_half_h - 0.2])
            square([2.8, DETACHABLE_SOURCE_LITE_THICKNESS + 0.4]);
    }
}

module _opengrid_main_section_dimensions() {
    lite_half_h = DETACHABLE_SOURCE_LITE_THICKNESS / 2;
    lower_half_w = DETACHABLE_SOURCE_LOWER_WIDTH / 2;
    capture_half_w = DETACHABLE_SOURCE_CAPTURE_WIDTH / 2;

    // Overall lower envelope, retained capture spacing and total Lite height.
    td_dimension_h(
        -lower_half_w,
         lower_half_w,
        -4.4,
        -lite_half_h
    );
    td_dimension_h(
        -capture_half_w,
         capture_half_w,
         3.35,
         1.1
    );
    td_dimension_v(
        -lite_half_h,
         lite_half_h,
         15.6,
         lower_half_w
    );
}

module _opengrid_local_detail_dimensions() {
    // Coordinates are relative to the 25.0 mm capture face after the detail is
    // translated by -capture_half_w.
    bottom_z = -DETACHABLE_SOURCE_LITE_THICKNESS / 2;
    lower_z = bottom_z + 1.6;
    ramp_top_z = lower_z + 1.0;
    capture_top_z = ramp_top_z + 1.0;
    top_z = DETACHABLE_SOURCE_LITE_THICKNESS / 2;

    // Radial offsets from the capture face.
    td_dimension_h(
        0,
        (DETACHABLE_SOURCE_LOWER_WIDTH - DETACHABLE_SOURCE_CAPTURE_WIDTH) / 2,
        bottom_z - 0.55,
        bottom_z
    );
    td_dimension_h(
        0,
        (DETACHABLE_SOURCE_TOP_WIDTH - DETACHABLE_SOURCE_CAPTURE_WIDTH) / 2,
        top_z + 0.55,
        top_z
    );

    // Retained vertical bands: 1.6 / 1.0 / 1.0 / 0.4 mm.
    td_dimension_v(bottom_z, lower_z, -1.25, 0);
    td_dimension_v(lower_z, ramp_top_z, -1.25, 0);
    td_dimension_v(ramp_top_z, capture_top_z, -1.25, 0);
    td_dimension_v(capture_top_z, top_z, -1.25, 0);
}

module _node_plan_slice_2d() {
    // Exact restored compact node tongue, sliced in the upper guide band.
    projection(cut = false)
        intersection() {
            node_receiver();
            // The lower constant-width band exposes the full 0.7 mm radial
            // recess and therefore makes the 1 mm longitudinal blends obvious.
            translate([-8, -8, 0.78])
                cube([16, 16, 0.04]);
        }
}

module _node_section_2d() {
    projection(cut = false)
        rotate([-90, 0, 0])
            node_receiver_retention_profile();
}

module _node_plan_dimensions() {
    td_dimension_h(-5, 5, -7.0, -5.0);
    td_dimension_h(-4, 4, -8.5, -5.0);
    td_dimension_h(-5, -4, -10.0, -5.0);
    td_dimension_h(4, 5, -10.0, -5.0);
}

module _node_section_dimensions() {
    td_dimension_h(
        -DETACHABLE_INTERFACE_WIDTH / 2,
         DETACHABLE_INTERFACE_WIDTH / 2,
        -2.2,
        0
    );
    td_dimension_v(
        0,
        DETACHABLE_INTERFACE_HEIGHT,
        7.2,
        DETACHABLE_INTERFACE_WIDTH / 2
    );
}

module opengrid_profile_a4() {
    design_bosl2_context()
        td_a4_landscape(
            "OPENGRID LITE FIXED-SIDE PROFILE",
            "OG-LITE-PROFILE",
            "AS SHOWN"
        ) {
            // View 1: small orientation/context view. Its job is only to make
            // clear where the straight edge and corner transition live.
            translate([58, 147])
                scale([2.3, 2.3])
                    _drawing_outline()
                        _opengrid_plan_slice_2d();

            translate([23, 190])
                text("VIEW A - PLAN / CORNER CONTEXT", size = 3.4);
            translate([23, 184])
                text("SCALE 2.3:1", size = 2.3);

            td_section_mark(58, 116, 177, "A");

            // View 2: primary information view. This receives most of the sheet
            // because the X/Z capture profile is what the node reduction uses.
            translate([148, 75])
                scale([6.0, 6.0]) {
                    _drawing_outline()
                        _opengrid_section_2d();
                    _opengrid_main_section_dimensions();
                }

            translate([88, 114])
                text("SECTION A-A - TRANSVERSE FIXED PROFILE", size = 3.6);
            translate([88, 108])
                text("SCALE 6:1", size = 2.3);

            // Mark the right-hand capture edge as the source of detail B.
            translate([226, 75])
                _drawing_outline(0.20)
                    circle(r = 9);
            translate([233, 83])
                text("B", size = 2.8);

            // View 3: enlarged crop of the exact source section. This is where
            // the small radial offsets and Z bands become readable.
            translate([246, 150])
                scale([14.0, 14.0]) {
                    translate([-DETACHABLE_SOURCE_CAPTURE_WIDTH / 2, 0])
                        _drawing_outline()
                            _opengrid_section_right_detail_2d();
                    _opengrid_local_detail_dimensions();
                }

            translate([211, 190])
                text("DETAIL B - CAPTURE PROFILE", size = 3.2);
            translate([211, 184])
                text("SCALE 14:1", size = 2.3);

            translate([20, 39])
                text("EXACT PINNED OPENGRID LITE RECEIVER GEOMETRY", size = 2.5);
            translate([20, 34])
                text("Experiment-owned drawing; all dimensions in mm.", size = 2.3);
        }
}

module node_profile_a4() {
    design_bosl2_context()
        td_a4_landscape(
            "NODE FIXED TONGUE PROFILE",
            "NODE-TONGUE-PROFILE",
            "8:1 / 8:1"
        ) {
            translate([78, 125])
                scale([8, 8]) {
                    rotate([0, 0, 90])
                        _drawing_outline()
                            _node_plan_slice_2d();
                    _node_plan_dimensions();
                }

            translate([36, 188])
                text("PLAN AT Z=0.8 - COMPLETE 10 mm LOCAL TONGUE", size = 4.0);

            td_section_mark(78, 77, 170, "A");

            translate([210, 102])
                scale([8.0, 8.0]) {
                    _drawing_outline()
                        _node_section_2d();
                    _node_section_dimensions();
                }

            translate([180, 169])
                text("A-A - ACTIVE CENTER SECTION", size = 4.0);

            translate([20, 42])
                text("10 mm total: 8 mm full-depth profile + 1 mm smooth radial-depth blend at each end.", size = 2.7);
            translate([20, 36])
                text("The blend returns to the ordinary 10 mm width while the top plane remains at Z = 4 mm.", size = 2.7);
        }
}

module mating_profile_design(view = "opengrid") {
    if (view == "opengrid")
        opengrid_profile_a4();
    else if (view == "node")
        node_profile_a4();
    else
        assert(false, str("unknown mating-profile view: ", view));
}
