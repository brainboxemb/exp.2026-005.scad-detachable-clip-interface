// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: embed the reduced receiver into a 50 x 10 x 4 rail.

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module receiver_rail_example(mm_pattern = true) {
    at01_receiver_rail(mm_pattern);
}

receiver_rail_example();
