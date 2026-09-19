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
// The design evidence follows the same construction as production:
// one source-derived X/Z profile, then one straight BOSL2 path extrusion.

module _node_receiver_design_center_y_slice() {
    translate([
        -node_receiver_width(),
        -0.5,
        -1
    ])
        cube([
            2 * node_receiver_width(),
            1.0,
            node_receiver_height() + 2
        ]);
}

module node_receiver_design_profile() {
    intersection() {
        node_receiver_build(false);
        _node_receiver_design_center_y_slice();
    }
}

module node_receiver_design_profile_vs_extrusion() {
    translate([-8, 0, 0])
        node_receiver_design_profile();

    translate([8, 0, 0])
        node_receiver_build(false);
}

module node_receiver_design_plain() {
    node_receiver_build(false);
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
