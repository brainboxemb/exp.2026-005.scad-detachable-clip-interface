// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned removable-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/node_interface.scad>

module node_snap_build(mm_pattern = true) {
    node_snap(mm_pattern);
}

module node_snap_profile() {
    node_snap_retention_profile();
}



// -----------------------------------------------------------------------------
// Design-documentation construction states
// -----------------------------------------------------------------------------
// These are explanatory states built from the same production modules as the
// final snap. They exist so design/design.md can show each geometric operation
// instead of jumping directly between coarse end states.

module node_snap_design_core_envelope() {
    _node_snap_core_outer_envelope();
}

module node_snap_design_positive_wall() {
    _node_snap_side_wall(1);
}

module node_snap_design_side_walls() {
    union() {
        _node_snap_side_wall(1);
        _node_snap_side_wall(-1);
    }
}

module node_snap_design_positive_nub_box() {
    _node_positive_x_nub_transform()
        _node_source_nub_box();
}

module node_snap_design_positive_nub_wedge_shaped() {
    _node_positive_x_nub_transform()
        _node_source_nub_wedge_shaped();
}

module node_snap_design_positive_nub_final() {
    _node_positive_x_nub();
}

module node_snap_design_nubs() {
    union() {
        _node_positive_x_nub();
        mirror([1, 0, 0])
            _node_positive_x_nub();
    }
}

module node_snap_design_walls_and_nubs() {
    union() {
        node_snap_design_side_walls();
        node_snap_design_nubs();
    }
}

module node_snap_design_before_slots() {
    union() {
        node_snap_design_walls_and_nubs();
        _node_snap_top();
    }
}

module node_snap_design_main_click_slot_cutters() {
    union() {
        _node_positive_x_click_slot();
        mirror([1, 0, 0])
            _node_positive_x_click_slot();
    }
}

module node_snap_design_after_main_click_slots() {
    difference() {
        node_snap_design_before_slots();
        node_snap_design_main_click_slot_cutters();
    }
}

module node_snap_design_top_slot_cutters() {
    union() {
        _node_positive_x_top_slot();
        mirror([1, 0, 0])
            _node_positive_x_top_slot();
    }
}

module node_snap_design_slot_cutters() {
    union() {
        node_snap_design_main_click_slot_cutters();
        node_snap_design_top_slot_cutters();
    }
}

module node_snap_design_plain() {
    difference() {
        node_snap_design_before_slots();
        node_snap_design_slot_cutters();
    }
}

module node_snap_design_pattern_cutters() {
    _node_mm_reference_cuts_at_top(
        node_snap_total_height(),
        node_snap_outer_width(),
        node_snap_length()
    );
}

// Standalone opening shows the primary snap object.
node_snap_build();
