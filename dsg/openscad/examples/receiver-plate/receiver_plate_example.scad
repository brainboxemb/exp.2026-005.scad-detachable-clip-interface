// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: place the standalone receiver object on a wider plate.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/detachable_clip_interface.scad>

module receiver_plate_example(mm_pattern = true) {
    detachable_clip_receiver_plate_example(mm_pattern);
}

receiver_plate_example();
