// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: reduced snap assembled on the plate carrier.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module receiver_plate_assembled_example(mm_pattern = true) {
    at01_assembled(1, mm_pattern = mm_pattern);
}

receiver_plate_assembled_example();
