// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// A4 fixed-side profile drawings.
//
// Each sheet deliberately contains two orthogonal descriptions:
// - a plan/longitudinal view showing how the feature runs and terminates;
// - section A-A showing the transverse X/Z profile.
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
            translate([-20, -20, 1.78])
                cube([40, 40, 0.04]);
        }
}

module _opengrid_section_2d() {
    projection(cut = false)
        rotate([-90, 0, 0])
            opengrid_lite_receiver_solid_profile();
}

module _node_plan_slice_2d() {
    // Exact restored compact node tongue, sliced in the upper guide band.
    projection(cut = false)
        intersection() {
            node_receiver();
            translate([-8, -8, 3.78])
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
            "4:1 / 5.8:1"
        ) {
            translate([76, 122])
                scale([4, 4])
                    _drawing_outline()
                        _opengrid_plan_slice_2d();

            translate([31, 188])
                text("PLAN - STRAIGHT EDGE AND CORNER TRANSITION", size = 4.0);

            td_section_mark(76, 75, 169, "A");

            translate([208, 101])
                scale([5.8, 5.8])
                    _drawing_outline()
                        _opengrid_section_2d();

            translate([196, 169])
                text("A-A", size = 4.0);

            translate([208, 101])
                scale([5.8, 5.8]) {
                    td_dimension_v(-2, 2, 17.0, 14.0);
                    td_dimension_h(-12.5, 12.5, -4.4, -2.0);
                }

            translate([20, 42])
                text("Exact pinned geometry; drawing is experiment-owned, not upstream OpenGrid documentation.", size = 2.7);
        }
}

module node_profile_a4() {
    design_bosl2_context()
        td_a4_landscape(
            "NODE FIXED TONGUE PROFILE",
            "NODE-TONGUE-PROFILE",
            "8:1 / 8.5:1"
        ) {
            translate([78, 125])
                scale([8, 8])
                    rotate([0, 0, 90]) {
                        _drawing_outline()
                            _node_plan_slice_2d();
                        _node_plan_dimensions();
                    }

            translate([36, 188])
                text("PLAN - COMPLETE 10 mm LOCAL TONGUE", size = 4.0);

            td_section_mark(78, 77, 170, "A");

            translate([218, 102])
                scale([8.5, 8.5]) {
                    _drawing_outline()
                        _node_section_2d();
                    _node_section_dimensions();
                }

            translate([190, 169])
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
