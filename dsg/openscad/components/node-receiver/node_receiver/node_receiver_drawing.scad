// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Dimensioned 2D receiver profile generated from the experiment geometry.

include <openscad-new-dimensions/constants.scad>
include <openscad-new-dimensions/dimensions.scad>
include <../../../lib/node_interface.scad>

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

module _receiver_profile() {
    _node_receiver_profile_2d();
}

module node_receiver_profile_drawing() {
    _outline_2d()
        _receiver_profile();

    // Main functional widths.
    _horizontal_dimension(
        -NODE_RECEIVER_WIDTH / 2,
         NODE_RECEIVER_WIDTH / 2,
        -3.0,
        NODE_RECEIVER_RAMP_TOP_Z
    );

    _horizontal_dimension(
        -NODE_RECEIVER_LOWER_WIDTH / 2,
         NODE_RECEIVER_LOWER_WIDTH / 2,
        -5.5,
        0
    );

    _horizontal_dimension(
        -NODE_RECEIVER_TOP_WIDTH / 2,
         NODE_RECEIVER_TOP_WIDTH / 2,
        6.5,
        NODE_RECEIVER_HEIGHT
    );

    // Overall Z envelope.
    _vertical_dimension(
        0,
        NODE_RECEIVER_HEIGHT,
        8.0,
        NODE_RECEIVER_WIDTH / 2
    );

    translate([-7.5, 10.0])
        text("NODE RECEIVER - X/Z RETENTION PROFILE", size = 1.35);

    translate([-7.5, 8.0])
        text("dimensions in mm", size = 0.9);
}
