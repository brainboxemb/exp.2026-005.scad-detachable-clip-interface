// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced node snap.

include <BOSL2/std.scad>

$fn = 120;

/* [Design view] */
view = "final"; // [final,core-envelope,positive-wall,side-walls,nub-box,nub-wedge-shaped,nub-final-one-side,nubs,top,main-click-slot-cutters,after-main-click-slots,top-slot-cutters,plain,pattern-cutters,profile]

use <../../../design_support.scad>
use <../node_snap.scad>

module node_snap_design(view = "final") {
    design_bosl2_context() {
        existing = [0.56, 0.56, 0.56, 0.42];
        current = [0.88, 0.08, 0.06, 0.82];

        if (view == "core-envelope") {
            color(current)
                node_snap_design_core_envelope();

        } else if (view == "positive-wall") {
            color(existing)
                node_snap_design_core_envelope();
            color(current)
                node_snap_design_positive_wall();

        } else if (view == "side-walls") {
            color(current)
                node_snap_design_side_walls();

        } else if (view == "nub-box") {
            color(existing)
                node_snap_design_side_walls();
            color(current)
                node_snap_design_positive_nub_box();

        } else if (view == "nub-wedge-shaped") {
            color(existing)
                node_snap_design_side_walls();
            color(current)
                node_snap_design_positive_nub_wedge_shaped();

        } else if (view == "nub-final-one-side") {
            color(existing)
                node_snap_design_side_walls();
            color(current)
                node_snap_design_positive_nub_final();

        } else if (view == "nubs") {
            color(existing)
                node_snap_design_side_walls();
            color(current)
                node_snap_design_nubs();

        } else if (view == "top") {
            color(existing)
                node_snap_design_walls_and_nubs();
            color(current)
                node_snap_design_top();

        } else if (view == "main-click-slot-cutters") {
            color(existing)
                node_snap_design_before_slots();
            color(current)
                node_snap_design_main_click_slot_cutters();

        } else if (view == "after-main-click-slots") {
            color(current)
                node_snap_design_after_main_click_slots();

        } else if (view == "top-slot-cutters") {
            color(existing)
                node_snap_design_after_main_click_slots();
            color(current)
                node_snap_design_top_slot_cutters();

        } else if (view == "plain") {
            color(current)
                node_snap_design_plain();

        } else if (view == "pattern-cutters") {
            color(existing)
                node_snap_design_plain();
            color(current)
                node_snap_design_pattern_cutters();

        } else if (view == "profile") {
            node_snap_profile();

        } else {
            node_snap_build(true);
        }
    }
}

node_snap_design(view = view);
