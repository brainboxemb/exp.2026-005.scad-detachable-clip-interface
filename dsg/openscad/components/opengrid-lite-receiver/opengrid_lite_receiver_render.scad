// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the pinned OpenGrid Lite receiver.

include <BOSL2/std.scad>

$fn = 120;

/* [Design view] */
view = "final"; // [final,full-source,retained-top,retained-top-only,recentered-extraction,recentering-compare,recentered-compare,lite-result,profile-zones,solid-profile,flex-profile]

use <../../design_support.scad>
use <opengrid_lite_receiver.scad>

module opengrid_lite_receiver_design(view = "final") {
    design_bosl2_context() {
        if (view == "full-source")
            opengrid_lite_receiver_design_full_source();
        else if (view == "retained-top")
            opengrid_lite_receiver_design_full_with_retained_top();
        else if (view == "retained-top-only")
            opengrid_lite_receiver_design_retained_top_only();
        else if (view == "recentered-extraction")
            opengrid_lite_receiver_design_recentered_extraction();
        else if (view == "recentering-compare")
            opengrid_lite_receiver_design_recentering_compare();
        else if (view == "recentered-compare")
            opengrid_lite_receiver_design_recentered_compare();
        else if (view == "lite-result")
            opengrid_lite_receiver_design_recentered_result();
        else if (view == "profile-zones")
            opengrid_lite_receiver_design_profile_zones();
        else if (view == "solid-profile")
            opengrid_lite_receiver_profile_view(false);
        else if (view == "flex-profile")
            opengrid_lite_receiver_profile_view(true);
        else
            opengrid_lite_receiver_build();
    }
}

opengrid_lite_receiver_design(view = view);
