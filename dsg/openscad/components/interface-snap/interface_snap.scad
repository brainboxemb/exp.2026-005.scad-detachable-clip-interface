// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Primary experiment-owned removable-side design object.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/at01_inverted_core_snap.scad>

module interface_snap_build(mm_pattern = true) {
    at01_removable_snap(mm_pattern);
}

module interface_snap_profile() {
    at01_snap_retention_profile();
}

// Standalone opening shows the primary snap object.
interface_snap_build();
