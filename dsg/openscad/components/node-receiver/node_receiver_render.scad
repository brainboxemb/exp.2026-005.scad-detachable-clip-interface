// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced node receiver.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <node_receiver.scad>

module node_receiver_design(view = "final") {
    design_bosl2_context() {
        existing = [0.56, 0.56, 0.56, 0.42];
        current = [0.88, 0.08, 0.06, 0.78];

        if (view == "base-block") {
            color(current)
                node_receiver_design_base_block();

        } else if (view == "lower-cutters") {
            color(existing)
                node_receiver_design_base_block();
            color(current)
                node_receiver_design_lower_cutters();

        } else if (view == "after-lower") {
            color(current)
                node_receiver_design_after_lower();

        } else if (view == "top-main-cutters") {
            color(existing)
                node_receiver_design_after_lower();
            color(current)
                node_receiver_design_top_main_cutters();

        } else if (view == "after-top-main") {
            color(current)
                node_receiver_design_after_top_main();

        } else if (view == "top-end-before") {
            color(current)
                node_receiver_design_after_top_main();

        } else if (view == "top-end-removed") {
            color(existing)
                node_receiver_design_after_top_main();
            color(current)
                node_receiver_design_top_end_removed_material();

        } else if (view == "top-end-after") {
            color(current)
                node_receiver_design_after_top_end();

        } else if (view == "top-end-before-after") {
            translate([-8, 0, 0])
                color(current)
                    node_receiver_design_after_top_main();
            translate([8, 0, 0])
                color(current)
                    node_receiver_design_after_top_end();

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

node_receiver_design();
