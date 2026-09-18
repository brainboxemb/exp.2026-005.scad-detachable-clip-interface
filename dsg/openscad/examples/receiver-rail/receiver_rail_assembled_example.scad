// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: reduced snap assembled on the rail carrier.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/node_interface.scad>

module receiver_rail_assembled_example(mm_pattern = true) {
    node_example_assembled(0, mm_pattern = mm_pattern);
}

receiver_rail_assembled_example();
