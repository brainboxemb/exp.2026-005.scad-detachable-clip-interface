// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned fixed-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module interface_receiver_build(mm_pattern = true) {
    at01_receiver_block(mm_pattern);
}

// Standalone opening shows the primary receiver object.
interface_receiver_build();
