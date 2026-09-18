// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned fixed-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/detachable_clip_interface.scad>

module interface_receiver_build(mm_pattern = true) {
    detachable_clip_receiver(mm_pattern);
}



// -----------------------------------------------------------------------------
// Design-documentation construction states
// -----------------------------------------------------------------------------
// These modules deliberately expose the construction sequence used by
// design/design.md. They do not introduce a second production geometry path;
// every cutter is the same cutter used by detachable_clip_receiver().

module interface_receiver_design_base_block() {
    translate([
        -detachable_clip_receiver_width() / 2,
        -detachable_clip_receiver_length() / 2,
        0
    ])
        cube([
            detachable_clip_receiver_width(),
            detachable_clip_receiver_length(),
            detachable_clip_receiver_height()
        ]);
}

module interface_receiver_design_lower_cutters() {
    union() {
        _clip_positive_x_lower_cut_active();
        _clip_positive_y_lower_cut_transition();
        mirror([0, 1, 0])
            _clip_positive_y_lower_cut_transition();

        mirror([1, 0, 0]) {
            _clip_positive_x_lower_cut_active();
            _clip_positive_y_lower_cut_transition();
            mirror([0, 1, 0])
                _clip_positive_y_lower_cut_transition();
        }
    }
}

module interface_receiver_design_top_main_cutters() {
    union() {
        _clip_positive_x_top_cut_active();
        mirror([1, 0, 0])
            _clip_positive_x_top_cut_active();
    }
}

module interface_receiver_design_top_end_cutters() {
    union() {
        _clip_positive_y_top_cut_transition();
        mirror([0, 1, 0])
            _clip_positive_y_top_cut_transition();

        mirror([1, 0, 0]) {
            _clip_positive_y_top_cut_transition();
            mirror([0, 1, 0])
                _clip_positive_y_top_cut_transition();
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
    _clip_mm_reference_cuts_at_top(
        detachable_clip_receiver_height(),
        detachable_clip_receiver_width(),
        detachable_clip_receiver_length()
    );
}

// Standalone opening shows the primary receiver object.
interface_receiver_build();
