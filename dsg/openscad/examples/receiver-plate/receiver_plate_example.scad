// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: place the standalone receiver object on a wider plate.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module receiver_plate_example(mm_pattern = true) {
    at01_receiver_plate(mm_pattern);
}

receiver_plate_example();
