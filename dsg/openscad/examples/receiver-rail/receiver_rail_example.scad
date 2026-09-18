// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: embed the reduced receiver into a 50 x 10 x 4 rail.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/detachable_clip_interface.scad>

module receiver_rail_example(mm_pattern = true) {
    detachable_clip_receiver_rail_example(mm_pattern);
}

receiver_rail_example();
