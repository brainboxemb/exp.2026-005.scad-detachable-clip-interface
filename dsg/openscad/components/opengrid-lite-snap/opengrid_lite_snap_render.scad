// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the pinned OpenGrid Lite snap.

include <BOSL2/std.scad>

$fn = 120;

use <../../design_support.scad>
use <opengrid_lite_snap.scad>

module opengrid_lite_snap_design(view = "final") {
    design_bosl2_context() {
        if (view == "core")
            opengrid_lite_snap_design_core();
        else if (view == "core-plus-top") {
            color([0.56, 0.56, 0.56, 0.42])
                opengrid_lite_snap_design_core();
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_top();
        } else if (view == "top-nub") {
            color([0.56, 0.56, 0.56, 0.42]) {
                opengrid_lite_snap_design_core();
                opengrid_lite_snap_design_top();
            }
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_top_nub();
        } else if (view == "nub-box") {
            color([0.56, 0.56, 0.56, 0.42]) {
                opengrid_lite_snap_design_core();
                opengrid_lite_snap_design_top();
                opengrid_lite_snap_design_top_nub();
            }
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_one_nub_box();
        } else if (view == "nub-wedge-shaped") {
            color([0.56, 0.56, 0.56, 0.42]) {
                opengrid_lite_snap_design_core();
                opengrid_lite_snap_design_top();
                opengrid_lite_snap_design_top_nub();
            }
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_one_nub_wedge_shaped();
        } else if (view == "nub-final-one-side") {
            color([0.56, 0.56, 0.56, 0.42]) {
                opengrid_lite_snap_design_core();
                opengrid_lite_snap_design_top();
                opengrid_lite_snap_design_top_nub();
            }
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_one_nub_final();
        } else if (view == "bottom-nubs") {
            color([0.56, 0.56, 0.56, 0.42]) {
                opengrid_lite_snap_design_core();
                opengrid_lite_snap_design_top();
                opengrid_lite_snap_design_top_nub();
            }
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_bottom_nubs();
        } else if (view == "body-before-slots")
            opengrid_lite_snap_design_body_before_slots();
        else if (view == "click-slot-cutters") {
            color([0.56, 0.56, 0.56, 0.42])
                opengrid_lite_snap_design_body_before_slots();
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_click_slot_cutters();
        } else if (view == "click-slot-section-removed") {
            color(existing)
                opengrid_lite_snap_design_click_slot_section_before();
            color(current)
                opengrid_lite_snap_design_click_slot_section_removed();
        } else if (view == "click-slot-section-before-after") {
            color(current)
                opengrid_lite_snap_design_click_slot_section_before_after();
        } else if (view == "after-click-slots")
            opengrid_lite_snap_design_after_click_slots();
        else if (view == "wall-slot-cutters") {
            color([0.56, 0.56, 0.56, 0.42])
                opengrid_lite_snap_design_after_click_slots();
            color([0.88, 0.08, 0.06, 0.82])
                opengrid_lite_snap_design_wall_slot_cutters();
        } else if (view == "reconstructed")
            opengrid_lite_snap_design_reconstructed();
        else if (view == "reconstruction-compare") {
            translate([-16, 0, 0])
                color([0.88, 0.08, 0.06])
                    opengrid_lite_snap_design_reconstructed();
            translate([16, 0, 0])
                color([0.56, 0.56, 0.56])
                    opengrid_lite_snap_build();
        } else if (view == "source-layers")
            opengrid_lite_snap_design_source_layers();
        else if (view == "solid-profile")
            opengrid_lite_snap_profile_view(false);
        else if (view == "flex-profile")
            opengrid_lite_snap_profile_view(true);
        else
            opengrid_lite_snap_build();
    }
}

opengrid_lite_snap_design();
