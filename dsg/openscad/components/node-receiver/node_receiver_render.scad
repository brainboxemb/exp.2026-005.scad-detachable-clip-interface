// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced node receiver.

include <BOSL2/std.scad>

$fn = 120;

/* [Design view] */
view = "final"; // [final,base-block,lower-removed,lower-profile,after-lower,top-profile-slice,top-guide-cutter,top-guide-before,top-guide-removed,top-guide-after,top-guide-before-after,plain,pattern-cutters]

use <../../design_support.scad>
use <node_receiver.scad>

module node_receiver_design(view = "final") {
    design_bosl2_context() {
        existing = [0.56, 0.56, 0.56, 0.42];
        current = [0.88, 0.08, 0.06, 0.78];

        if (view == "base-block") {
            color(current)
                node_receiver_design_base_block();

        } else if (view == "lower-removed") {
            // Separate the before-state and the exact removed material so
            // cutter volume outside the part cannot be mistaken for geometry.
            translate([-8, 0, 0])
                color(existing)
                    node_receiver_design_base_block();
            translate([8, 0, 0])
                color(current)
                    node_receiver_design_lower_removed_material();

        } else if (view == "lower-profile") {
            translate([-7, 0, 0])
                color(current)
                    node_receiver_design_lower_removed_profile();

            translate([7, 0, 0])
                color(existing)
                    node_receiver_design_lower_after_profile();

        } else if (view == "after-lower") {
            color(current)
                node_receiver_design_after_lower();

        } else if (view == "top-profile-slice") {
            color(existing)
                node_receiver_design_after_lower();
            color(current)
                node_receiver_design_top_profile_slice();

        } else if (view == "top-guide-cutter") {
            color(current)
                node_receiver_design_top_guide_cutters();

        } else if (view == "top-guide-before") {
            color(current)
                node_receiver_design_after_lower();

        } else if (view == "top-guide-removed") {
            translate([-8, 0, 0])
                color(existing)
                    node_receiver_design_after_lower();
            translate([8, 0, 0])
                color(current)
                    node_receiver_design_top_removed_material();

        } else if (view == "top-guide-after") {
            color(current)
                node_receiver_design_after_top_guide();

        } else if (view == "top-guide-before-after") {
            translate([-8, 0, 0])
                color(current)
                    node_receiver_design_after_lower();
            translate([8, 0, 0])
                color(current)
                    node_receiver_design_after_top_guide();

        } else if (view == "plain") {
            color(current)
                node_receiver_design_plain();

        } else if (view == "pattern-cutters") {
            color(existing)
                node_receiver_design_plain();
            color(current)
                node_receiver_design_pattern_cutters();

        } else {
            node_receiver_build(true);
        }
    }
}

node_receiver_design(view = view);
