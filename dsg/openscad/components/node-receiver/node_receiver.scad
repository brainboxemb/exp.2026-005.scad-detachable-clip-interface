// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned fixed-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/node_interface.scad>

module node_receiver_build(mm_pattern = true) {
    node_receiver(mm_pattern);
}



// -----------------------------------------------------------------------------
// Design-documentation construction states
// -----------------------------------------------------------------------------
// These modules deliberately expose the construction sequence used by
// design/design.md. They do not introduce a second production geometry path;
// every cutter is the same cutter used by node_receiver().

module node_receiver_design_base_block() {
    translate([
        -node_receiver_width() / 2,
        -node_receiver_length() / 2,
        0
    ])
        cube([
            node_receiver_width(),
            node_receiver_length(),
            node_receiver_height()
        ]);
}

module node_receiver_design_lower_cutters() {
    union() {
        _node_positive_x_lower_cut_active();
        _node_positive_y_lower_cut_transition();
        mirror([0, 1, 0])
            _node_positive_y_lower_cut_transition();

        mirror([1, 0, 0]) {
            _node_positive_x_lower_cut_active();
            _node_positive_y_lower_cut_transition();
            mirror([0, 1, 0])
                _node_positive_y_lower_cut_transition();
        }
    }
}

module node_receiver_design_top_main_cutters() {
    union() {
        _node_positive_x_top_cut_active();
        mirror([1, 0, 0])
            _node_positive_x_top_cut_active();
    }
}

module node_receiver_design_top_end_cutters() {
    union() {
        _node_positive_y_top_cut_transition();
        mirror([0, 1, 0])
            _node_positive_y_top_cut_transition();

        mirror([1, 0, 0]) {
            _node_positive_y_top_cut_transition();
            mirror([0, 1, 0])
                _node_positive_y_top_cut_transition();
        }
    }
}

module node_receiver_design_after_lower() {
    difference() {
        node_receiver_design_base_block();
        node_receiver_design_lower_cutters();
    }
}

module node_receiver_design_after_top_main() {
    difference() {
        node_receiver_design_after_lower();
        node_receiver_design_top_main_cutters();
    }
}

module node_receiver_design_top_end_removed_material() {
    // Show only cutter volume that actually intersects the current part.
    // This is more useful in the design record than displaying the complete
    // mathematical cutter, most of which intentionally lies outside the part.
    intersection() {
        node_receiver_design_after_top_main();
        node_receiver_design_top_end_cutters();
    }
}

module node_receiver_design_after_top_end() {
    difference() {
        node_receiver_design_after_top_main();
        node_receiver_design_top_end_cutters();
    }
}

module node_receiver_design_plain() {
    node_receiver_design_after_top_end();
}

module node_receiver_design_pattern_cutters() {
    _node_mm_reference_cuts_at_top(
        node_receiver_height(),
        node_receiver_width(),
        node_receiver_length()
    );
}

// Standalone opening shows the primary receiver object.
node_receiver_build();
