// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Dimensioned 2D snap retention section generated from the experiment geometry.

include <openscad-new-dimensions/constants.scad>
include <openscad-new-dimensions/dimensions.scad>
include <../../../lib/node_interface.scad>
use <../../../design_support.scad>

DIMENSION_RENDER_MODE = DIMENSION_RENDER_MODE_2D;
DIMENSION_COLOR = "black";
DIMENSION_LINE_WIDTH = 0.10;
DIMENSION_FONTSIZE = 0.16;
DIMENSION_ARROW_WIDTH = 0.32;
DIMENSION_ARROW_LENGTH = 6;
DIMENSION_ARROW_HOLLOW = 1;

DRAWING_LINE_WIDTH = 0.10;
EXTENSION_LINE_WIDTH = 0.06;

module _outline_2d(width = DRAWING_LINE_WIDTH) {
    difference() {
        offset(delta = width / 2)
            children();
        offset(delta = -width / 2)
            children();
    }
}

module _vertical_extension(x, y0, y1, width = EXTENSION_LINE_WIDTH) {
    translate([x - width / 2, min(y0, y1)])
        square([width, abs(y1 - y0)]);
}

module _horizontal_extension(x0, x1, y, width = EXTENSION_LINE_WIDTH) {
    translate([min(x0, x1), y - width / 2])
        square([abs(x1 - x0), width]);
}

module _horizontal_dimension(x0, x1, y, extension_from_y) {
    _vertical_extension(x0, extension_from_y, y);
    _vertical_extension(x1, extension_from_y, y);
    translate([x0, y])
        Dimension(length = x1 - x0);
}

module _vertical_dimension(y0, y1, x, extension_from_x) {
    _horizontal_extension(extension_from_x, x, y0);
    _horizontal_extension(extension_from_x, x, y1);
    translate([x, y0])
        rotate([0, 0, 90])
            Dimension(length = y1 - y0);
}

module _snap_retention_profile_2d() {
    projection(cut = false)
        rotate([-90, 0, 0])
            node_snap_retention_profile();
}

module node_snap_profile_drawing() {
    design_bosl2_context() {
        _outline_2d()
            _snap_retention_profile_2d();

        // Outer envelope, inner body clearance and retained nub opening.
    _horizontal_dimension(
        -NODE_SNAP_OUTER_WIDTH / 2,
         NODE_SNAP_OUTER_WIDTH / 2,
        7.2,
        NODE_SNAP_TOTAL_HEIGHT
    );

    _horizontal_dimension(
        -NODE_SNAP_INNER_WIDTH / 2,
         NODE_SNAP_INNER_WIDTH / 2,
        -3.0,
        0
    );

    _horizontal_dimension(
        -NODE_SNAP_NUB_OPENING / 2,
         NODE_SNAP_NUB_OPENING / 2,
        -5.5,
        OPENGRID_SNAP_NUB_HEIGHT
    );

    // Engagement and complete snap height.
    _vertical_dimension(
        0,
        NODE_SNAP_ENGAGEMENT_HEIGHT,
        10.0,
        NODE_SNAP_OUTER_WIDTH / 2
    );

    _vertical_dimension(
        0,
        NODE_SNAP_TOTAL_HEIGHT,
        13.0,
        NODE_SNAP_OUTER_WIDTH / 2
    );

    translate([-9.0, 11.0])
        text("NODE SNAP - X/Z RETENTION SECTION", size = 1.35);

        translate([-9.0, 9.0])
            text("dimensions in mm", size = 0.9);
    }
}
