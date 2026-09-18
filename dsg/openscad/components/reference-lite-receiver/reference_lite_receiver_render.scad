// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the pinned OpenGrid Lite receiver.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <reference_lite_receiver.scad>

module reference_lite_receiver_design(view = "final") {
    design_bosl2_context() {
        if (view == "profile-zones")
            reference_lite_receiver_design_profile_zones();
        else if (view == "solid-profile")
            reference_lite_receiver_profile(false);
        else if (view == "flex-profile")
            reference_lite_receiver_profile(true);
        else
            reference_lite_receiver_build();
    }
}

reference_lite_receiver_design();
