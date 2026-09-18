// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the pinned OpenGrid Lite snap.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <reference_lite_snap.scad>

module reference_lite_snap_design(view = "final") {
    design_bosl2_context() {
        if (view == "source-layers")
            reference_lite_snap_design_source_layers();
        else if (view == "solid-profile")
            reference_lite_snap_profile(false);
        else if (view == "flex-profile")
            reference_lite_snap_profile(true);
        else
            reference_lite_snap_build();
    }
}

reference_lite_snap_design();
