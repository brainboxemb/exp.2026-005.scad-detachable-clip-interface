// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the pinned OpenGrid Lite receiver.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <opengrid_lite_receiver.scad>

module opengrid_lite_receiver_design(view = "final") {
    design_bosl2_context() {
        if (view == "profile-zones")
            opengrid_lite_receiver_design_profile_zones();
        else if (view == "solid-profile")
            opengrid_lite_receiver_profile(false);
        else if (view == "flex-profile")
            opengrid_lite_receiver_profile(true);
        else
            opengrid_lite_receiver_build();
    }
}

opengrid_lite_receiver_design();
