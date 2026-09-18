// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced detachable-interface snap.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <interface_snap.scad>

module interface_snap_design(view = "final") {
    design_bosl2_context() {
        existing = [0.56, 0.56, 0.56, 0.42];
        current = [0.88, 0.08, 0.06, 0.78];

        if (view == "side-walls") {
            color(current)
                interface_snap_design_side_walls();

        } else if (view == "nubs") {
            color(existing)
                interface_snap_design_side_walls();
            color(current)
                interface_snap_design_nubs();

        } else if (view == "top") {
            color(existing)
                union() {
                    interface_snap_design_side_walls();
                    interface_snap_design_nubs();
                }
            color(current)
                _at01_snap_top();

        } else if (view == "slot-cutters") {
            color(existing)
                interface_snap_design_before_slots();
            color(current)
                interface_snap_design_slot_cutters();

        } else if (view == "plain") {
            color(current)
                interface_snap_design_plain();

        } else if (view == "pattern-cutters") {
            color(existing)
                interface_snap_design_plain();
            color(current)
                interface_snap_design_pattern_cutters();

        } else if (view == "profile") {
            interface_snap_profile();

        } else {
            interface_snap_build(true);
        }
    }
}

interface_snap_design();
