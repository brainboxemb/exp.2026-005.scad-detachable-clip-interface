// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Stage-2 minimal receiver reference-implementation drawing.

include <../../../lib/node_interface.scad>
use <../../../lib/technical_drawing.scad>
use <../../../design_support.scad>

module node_receiver_profile_drawing() {
    design_bosl2_context()
        td_frame(
            "MINIMAL RECEIVER - REFERENCE IMPLEMENTATION",
            "implements detachable-interface contract; carrier geometry excluded",
            "7:1"
        ) {
            translate([62, 56])
                scale([7, 7]) {
                    td_outline()
                        _node_receiver_profile_2d();

                    td_dimension_h(
                        -NODE_RECEIVER_WIDTH / 2,
                         NODE_RECEIVER_WIDTH / 2,
                        -2.0,
                        NODE_RECEIVER_RAMP_TOP_Z
                    );
                    td_dimension_h(
                        -NODE_RECEIVER_LOWER_WIDTH / 2,
                         NODE_RECEIVER_LOWER_WIDTH / 2,
                        -3.1,
                        0
                    );
                    td_dimension_h(
                        -NODE_RECEIVER_TOP_WIDTH / 2,
                         NODE_RECEIVER_TOP_WIDTH / 2,
                        5.4,
                        NODE_RECEIVER_HEIGHT
                    );
                    td_dimension_v(
                        0,
                        NODE_RECEIVER_HEIGHT,
                        8.0,
                        NODE_RECEIVER_WIDTH / 2
                    );
                }

            translate([122, 101])
                text("CONTRACT", size = 3.0);
            translate([122, 95])
                text("capture 10.0", size = 2.5);
            translate([122, 90])
                text("height   4.0", size = 2.5);
            translate([122, 85])
                text("length  10.0 ref.", size = 2.5);
        }
}
