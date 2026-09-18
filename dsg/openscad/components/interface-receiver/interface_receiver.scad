// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned fixed-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module interface_receiver_build(mm_pattern = true) {
    at01_receiver_block(mm_pattern);
}



// -----------------------------------------------------------------------------
// Design-documentation construction states
// -----------------------------------------------------------------------------
// These modules deliberately expose the construction sequence used by
// design/design.md. They do not introduce a second production geometry path;
// every cutter is the same cutter used by at01_receiver_block().

module interface_receiver_design_base_block() {
    translate([
        -at01_receiver_width() / 2,
        -at01_receiver_block_length() / 2,
        0
    ])
        cube([
            at01_receiver_width(),
            at01_receiver_block_length(),
            at01_receiver_height()
        ]);
}

module interface_receiver_design_lower_cutters() {
    union() {
        _at01_positive_x_lower_cut_active();
        _at01_positive_y_lower_cut_transition();
        mirror([0, 1, 0])
            _at01_positive_y_lower_cut_transition();

        mirror([1, 0, 0]) {
            _at01_positive_x_lower_cut_active();
            _at01_positive_y_lower_cut_transition();
            mirror([0, 1, 0])
                _at01_positive_y_lower_cut_transition();
        }
    }
}

module interface_receiver_design_top_main_cutters() {
    union() {
        _at01_positive_x_top_cut_active();
        mirror([1, 0, 0])
            _at01_positive_x_top_cut_active();
    }
}

module interface_receiver_design_top_end_cutters() {
    union() {
        _at01_positive_y_top_cut_transition();
        mirror([0, 1, 0])
            _at01_positive_y_top_cut_transition();

        mirror([1, 0, 0]) {
            _at01_positive_y_top_cut_transition();
            mirror([0, 1, 0])
                _at01_positive_y_top_cut_transition();
        }
    }
}

module interface_receiver_design_after_lower() {
    difference() {
        interface_receiver_design_base_block();
        interface_receiver_design_lower_cutters();
    }
}

module interface_receiver_design_after_top_main() {
    difference() {
        interface_receiver_design_after_lower();
        interface_receiver_design_top_main_cutters();
    }
}

module interface_receiver_design_plain() {
    difference() {
        interface_receiver_design_after_top_main();
        interface_receiver_design_top_end_cutters();
    }
}

module interface_receiver_design_pattern_cutters() {
    _at01_mm_reference_cuts_at_top(
        at01_receiver_height(),
        at01_receiver_width(),
        at01_receiver_block_length()
    );
}

// Standalone opening shows the primary receiver object.
interface_receiver_build();
