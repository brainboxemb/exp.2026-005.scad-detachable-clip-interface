// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: embed the reduced receiver into a 50 x 10 x 4 rail.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/node_interface.scad>

module receiver_rail_example(mm_pattern = true) {
    node_receiver_rail_example(mm_pattern);
}

receiver_rail_example();
