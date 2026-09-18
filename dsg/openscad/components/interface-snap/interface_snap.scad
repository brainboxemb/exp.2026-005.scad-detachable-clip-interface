// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned removable-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/detachable_clip_interface.scad>

module interface_snap_build(mm_pattern = true) {
    detachable_clip_snap(mm_pattern);
}

module interface_snap_profile() {
    detachable_clip_snap_retention_profile();
}



// -----------------------------------------------------------------------------
// Design-documentation construction states
// -----------------------------------------------------------------------------
// These are explanatory states built from the same production modules as the
// final snap. They exist so design/design.md can show what each operation does.

module interface_snap_design_side_walls() {
    union() {
        _clip_snap_side_wall(1);
        _clip_snap_side_wall(-1);
    }
}

module interface_snap_design_nubs() {
    union() {
        _clip_positive_x_nub();
        mirror([1, 0, 0])
            _clip_positive_x_nub();
    }
}

module interface_snap_design_before_slots() {
    union() {
        interface_snap_design_side_walls();
        interface_snap_design_nubs();
        _clip_snap_top();
    }
}

module interface_snap_design_slot_cutters() {
    union() {
        _clip_positive_x_click_slot();
        _clip_positive_x_top_slot();

        mirror([1, 0, 0]) {
            _clip_positive_x_click_slot();
            _clip_positive_x_top_slot();
        }
    }
}

module interface_snap_design_plain() {
    difference() {
        interface_snap_design_before_slots();
        interface_snap_design_slot_cutters();
    }
}

module interface_snap_design_pattern_cutters() {
    _clip_mm_reference_cuts_at_top(
        detachable_clip_snap_total_height(),
        detachable_clip_snap_outer_width(),
        detachable_clip_snap_length()
    );
}

// Standalone opening shows the primary snap object.
interface_snap_build();
