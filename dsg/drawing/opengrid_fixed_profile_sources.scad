// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Raw geometry views for the composed OpenGrid Lite technical drawing.
//
// This file deliberately contains no sheet layout or dimensions.  OpenSCAD
// owns the source geometry/projection; the project-owned Python drawing
// producer owns the A4 composition and annotations.

include <../openscad/lib/detachable_interface_spec.scad>
use <../openscad/lib/opengrid_reference.scad>

drawing_source_view =
    is_undef(drawing_source_view) ? "section" : drawing_source_view;

module orientation_view() {
    projection(cut = false)
        rotate([62, 0, 42])
            opengrid_lite_receiver();
}

module section_view() {
    projection(cut = false)
        rotate([-90, 0, 0])
            opengrid_lite_receiver_solid_profile();
}

module capture_detail_view() {
    capture_x = DETACHABLE_SOURCE_CAPTURE_WIDTH / 2;
    lite_half_h = DETACHABLE_SOURCE_LITE_THICKNESS / 2;

    intersection() {
        section_view();
        translate([capture_x - 1.0, -lite_half_h - 0.2])
            square([2.8, DETACHABLE_SOURCE_LITE_THICKNESS + 0.4]);
    }
}

lower_z = detachable_interface_lower_z(DETACHABLE_SOURCE_LITE_THICKNESS);
ramp_top_z = detachable_interface_ramp_top_z(DETACHABLE_SOURCE_LITE_THICKNESS);
capture_top_z =
    detachable_interface_capture_top_z(DETACHABLE_SOURCE_LITE_THICKNESS);

echo(str(
    "DRAWING_META:",
    DETACHABLE_SOURCE_CAPTURE_WIDTH, ",",
    DETACHABLE_SOURCE_LOWER_WIDTH, ",",
    DETACHABLE_SOURCE_TOP_WIDTH, ",",
    DETACHABLE_SOURCE_LITE_THICKNESS, ",",
    DETACHABLE_SOURCE_INSIDE_EXTRUSION, ",",
    DETACHABLE_SOURCE_TOP_CHAMFER, ",",
    lower_z, ",",
    ramp_top_z - lower_z, ",",
    capture_top_z - ramp_top_z, ",",
    DETACHABLE_SOURCE_LITE_THICKNESS - capture_top_z
));

if (drawing_source_view == "orientation")
    orientation_view();
else if (drawing_source_view == "section")
    section_view();
else if (drawing_source_view == "detail")
    capture_detail_view();
else
    assert(false, str("unknown drawing_source_view: ", drawing_source_view));
