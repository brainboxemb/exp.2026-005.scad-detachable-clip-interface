// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced detachable-interface receiver.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <interface_receiver.scad>

module interface_receiver_design(view = "final") {
    design_bosl2_context() {
        existing = [0.56, 0.56, 0.56, 0.42];
        current = [0.88, 0.08, 0.06, 0.78];

        if (view == "base-block") {
            color(current)
                interface_receiver_design_base_block();

        } else if (view == "lower-cutters") {
            color(existing)
                interface_receiver_design_base_block();
            color(current)
                interface_receiver_design_lower_cutters();

        } else if (view == "after-lower") {
            color(current)
                interface_receiver_design_after_lower();

        } else if (view == "top-main-cutters") {
            color(existing)
                interface_receiver_design_after_lower();
            color(current)
                interface_receiver_design_top_main_cutters();

        } else if (view == "after-top-main") {
            color(current)
                interface_receiver_design_after_top_main();

        } else if (view == "top-end-cutters") {
            color(existing)
                interface_receiver_design_after_top_main();
            color(current)
                interface_receiver_design_top_end_cutters();

        } else if (view == "plain") {
            color(current)
                interface_receiver_design_plain();

        } else if (view == "pattern-cutters") {
            color(existing)
                interface_receiver_design_plain();
            color(current)
                interface_receiver_design_pattern_cutters();

        } else {
            interface_receiver_build(true);
        }
    }
}

interface_receiver_design();
