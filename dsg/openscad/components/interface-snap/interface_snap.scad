// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned removable-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module interface_snap_build(mm_pattern = true) {
    at01_removable_snap(mm_pattern);
}

module interface_snap_profile() {
    at01_snap_retention_profile();
}



// -----------------------------------------------------------------------------
// Design-documentation construction states
// -----------------------------------------------------------------------------
// These are explanatory states built from the same production modules as the
// final snap. They exist so design/design.md can show what each operation does.

module interface_snap_design_side_walls() {
    union() {
        _at01_snap_side_wall(1);
        _at01_snap_side_wall(-1);
    }
}

module interface_snap_design_nubs() {
    union() {
        _at01_positive_x_nub();
        mirror([1, 0, 0])
            _at01_positive_x_nub();
    }
}

module interface_snap_design_before_slots() {
    union() {
        interface_snap_design_side_walls();
        interface_snap_design_nubs();
        _at01_snap_top();
    }
}

module interface_snap_design_slot_cutters() {
    union() {
        _at01_positive_x_click_slot();
        _at01_positive_x_top_slot();

        mirror([1, 0, 0]) {
            _at01_positive_x_click_slot();
            _at01_positive_x_top_slot();
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
    _at01_mm_reference_cuts_at_top(
        AT01_SNAP_TOTAL_HEIGHT,
        AT01_SNAP_OUTER_WIDTH,
        AT01_SNAP_LENGTH
    );
}

// Standalone opening shows the primary snap object.
interface_snap_build();
