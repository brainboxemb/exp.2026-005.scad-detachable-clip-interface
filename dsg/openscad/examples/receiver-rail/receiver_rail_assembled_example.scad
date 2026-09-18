// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Integration example: reduced snap assembled on the rail carrier.

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module receiver_rail_assembled_example(mm_pattern = true) {
    at01_assembled(0, mm_pattern = mm_pattern);
}

receiver_rail_assembled_example();
