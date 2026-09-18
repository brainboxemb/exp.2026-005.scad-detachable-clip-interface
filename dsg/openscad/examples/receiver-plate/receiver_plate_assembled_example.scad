// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: reduced snap assembled on the plate carrier.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/detachable_clip_interface.scad>

module receiver_plate_assembled_example(mm_pattern = true) {
    detachable_clip_example_assembled(1, mm_pattern = mm_pattern);
}

receiver_plate_assembled_example();
