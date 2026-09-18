// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Thin design-object wrapper around the pinned QuackWorks/OpenGrid Lite snap.
// See LICENSE and docs/00-source-provenance.md.

include <BOSL2/std.scad>

$fn = 120;

use <../../lib/opengrid_reference.scad>

module opengrid_lite_snap_build() {
    opengrid_lite_snap();
}

module opengrid_lite_snap_profile_view(flex_slot_plane = false) {
    if (flex_slot_plane)
        opengrid_lite_snap_profile();
    else
        opengrid_lite_snap_solid_profile();
}



// Step-by-step reconstruction of the non-directional Lite snap from the pinned
// QuackWorks source. These helpers copy only the relevant source construction
// into the experiment-owned wrapper so the design record can expose intermediate
// states. The final comparison still uses the pinned upstream module.

function _og_lite_snap_w() = 24.80;
function _og_lite_snap_h() = 3.4;
function _og_lite_snap_core_h() = 3.0;
function _og_lite_snap_top_h() = 0.4;
function _og_lite_snap_top_nub_h() = 1.1;

module _og_lite_snap_centered_source_space() {
    translate([0, 0, -_og_lite_snap_h() / 2])
        children();
}

module opengrid_lite_snap_design_core() {
    _og_lite_snap_centered_source_space()
        cuboid(
            [_og_lite_snap_w(), _og_lite_snap_w(), _og_lite_snap_core_h()],
            rounding = 4.81837,
            edges = "Z",
            $fn = 2,
            anchor = BOTTOM
        );
}

module opengrid_lite_snap_design_top() {
    _og_lite_snap_centered_source_space()
        translate([
            0,
            0,
            _og_lite_snap_h() - _og_lite_snap_top_h() - 0.01
        ])
            cuboid(
                [
                    _og_lite_snap_w(),
                    _og_lite_snap_w(),
                    _og_lite_snap_top_h() + 0.01
                ],
                rounding = 3.262743,
                edges = "Z",
                $fn = 2,
                anchor = BOTTOM
            );
}

module opengrid_lite_snap_design_top_nub() {
    w = _og_lite_snap_w();
    core = _og_lite_snap_core_h();
    top_nub_h = _og_lite_snap_top_nub_h();
    offs = 2.02;

    _og_lite_snap_centered_source_space()
        intersection() {
            translate([0, 0, core - top_nub_h - 0.01])
                cuboid(
                    [w, w, top_nub_h + 0.01],
                    rounding = 3.262743,
                    edges = "Z",
                    $fn = 2,
                    anchor = BOTTOM
                );

            zrot_copies(n = 4)
                move([w / 2 - offs, w / 2 - offs, core])
                    rotate([180, 0, 135])
                        wedge(
                            size = [6.817, top_nub_h, top_nub_h],
                            anchor = CENTER + BOTTOM
                        );
        }
}

module _og_lite_snap_design_normal_nub_local() {
    w = _og_lite_snap_w();
    nub_h = 0.2;
    nub_w = 11;
    nub_d = 0.4;
    top_wedge_h = 0.6;
    bot_wedge_h = 0.6;

    move([w / 2 - 0.01, 0, 0])
        intersection() {
            difference() {
                zmove(nub_h - 0.01)
                    cuboid(
                        [nub_d, nub_w, 2 - nub_h + 0.01],
                        anchor = CENTER + LEFT + BOTTOM
                    );

                zmove(2)
                    rotate([0, 180, 90])
                        wedge(
                            [nub_w, nub_d, top_wedge_h],
                            anchor = CENTER + BOTTOM + BACK
                        );

                zmove(nub_h)
                    rotate([0, 0, 90])
                        wedge(
                            [nub_w, 0.4, bot_wedge_h],
                            anchor = CENTER + BOTTOM + BACK
                        );
            }

            xmove(-12.36)
                yscale(1.36)
                    cyl(
                        $fn = 180,
                        r = 13.025,
                        h = 2.01,
                        anchor = BOTTOM
                    );
        }
}

module opengrid_lite_snap_design_bottom_nubs() {
    _og_lite_snap_centered_source_space()
        zrot_copies(n = 4)
            _og_lite_snap_design_normal_nub_local();
}

module opengrid_lite_snap_design_body_before_slots() {
    union() {
        opengrid_lite_snap_design_core();
        opengrid_lite_snap_design_top();
        opengrid_lite_snap_design_top_nub();
        opengrid_lite_snap_design_bottom_nubs();
    }
}

module opengrid_lite_snap_design_click_slot_cutters() {
    w = _og_lite_snap_w();

    _og_lite_snap_centered_source_space()
        zrot_copies(n = 4)
            move([w / 2 - 1, 0, 0])
                cuboid(
                    [0.6, 12.4, 1.5],
                    rounding = 0.3,
                    $fn = 100,
                    edges = "Z",
                    anchor = BOTTOM
                );
}

module opengrid_lite_snap_design_after_click_slots() {
    difference() {
        opengrid_lite_snap_design_body_before_slots();
        opengrid_lite_snap_design_click_slot_cutters();
    }
}

module opengrid_lite_snap_design_wall_slot_cutters() {
    w = _og_lite_snap_w();

    _og_lite_snap_centered_source_space()
        zrot_copies(n = 4)
            move([w / 2, 0, 2.2])
                cuboid([1.4, 12, 0.4], anchor = BOTTOM);
}

module opengrid_lite_snap_design_reconstructed() {
    difference() {
        opengrid_lite_snap_design_body_before_slots();
        opengrid_lite_snap_design_click_slot_cutters();
        opengrid_lite_snap_design_wall_slot_cutters();
    }
}

// Design-analysis view: color the exact final Lite snap by the two principal
// source construction layers. The source is CENTER anchored at h=3.4, so
// local 0..3.0 core maps to global -1.7..+1.3 and the 0.4 top maps to +1.3..+1.7.

module _opengrid_lite_snap_z_band(z0, z1) {
    intersection() {
        opengrid_lite_snap_build();
        translate([-30, -30, z0])
            cube([60, 60, z1 - z0]);
    }
}

module opengrid_lite_snap_design_source_layers() {
    color([0.58, 0.58, 0.58, 1.0])
        _opengrid_lite_snap_z_band(-1.7, 1.3);
    color([0.88, 0.08, 0.06, 1.0])
        _opengrid_lite_snap_z_band(1.3, 1.7);
}

// Standalone opening shows the primary OpenGrid source object.
opengrid_lite_snap_build();
