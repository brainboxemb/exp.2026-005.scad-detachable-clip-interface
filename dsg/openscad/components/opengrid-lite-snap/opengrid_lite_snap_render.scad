// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the pinned OpenGrid Lite snap.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <opengrid_lite_snap.scad>

module opengrid_lite_snap_design(view = "final") {
    design_bosl2_context() {
        if (view == "source-layers")
            opengrid_lite_snap_design_source_layers();
        else if (view == "solid-profile")
            opengrid_lite_snap_profile(false);
        else if (view == "flex-profile")
            opengrid_lite_snap_profile(true);
        else
            opengrid_lite_snap_build();
    }
}

opengrid_lite_snap_design();
