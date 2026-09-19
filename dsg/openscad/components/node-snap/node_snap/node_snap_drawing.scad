// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Stage-2 minimal snap reference-implementation drawing.

include <../../../lib/node_interface.scad>
use <../../../lib/technical_drawing.scad>
use <../../../design_support.scad>

module _snap_retention_profile_2d() {
    projection(cut = false)
        rotate([-90, 0, 0])
            node_snap_retention_profile();
}

module node_snap_profile_drawing() {
    design_bosl2_context()
        td_frame(
            "MINIMAL SNAP - REFERENCE IMPLEMENTATION",
            "implements detachable-interface contract; flex/support details are implementation-owned",
            "6:1"
        ) {
            translate([56, 55])
                scale([6, 6]) {
                    td_outline()
                        _snap_retention_profile_2d();

                    td_dimension_h(
                        -NODE_SNAP_OUTER_WIDTH / 2,
                         NODE_SNAP_OUTER_WIDTH / 2,
                        6.2,
                        NODE_SNAP_TOTAL_HEIGHT
                    );
                    td_dimension_h(
                        -NODE_SNAP_INNER_WIDTH / 2,
                         NODE_SNAP_INNER_WIDTH / 2,
                        -2.2,
                        0
                    );
                    td_dimension_h(
                        -NODE_SNAP_NUB_OPENING / 2,
                         NODE_SNAP_NUB_OPENING / 2,
                        -3.4,
                        OPENGRID_SNAP_NUB_HEIGHT
                    );
                    td_dimension_v(
                        0,
                        NODE_SNAP_ENGAGEMENT_HEIGHT,
                        10.0,
                        NODE_SNAP_OUTER_WIDTH / 2
                    );
                }

            translate([126, 101])
                text("CONTRACT", size = 3.0);
            translate([126, 95])
                text("inner   10.2", size = 2.5);
            translate([126, 90])
                text("opening  9.4", size = 2.5);
            translate([126, 85])
                text("engage   3.4", size = 2.5);
        }
}
