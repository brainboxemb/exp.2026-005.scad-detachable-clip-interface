// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Legacy OpenSCAD-only presentation helper for sheets that have not yet moved
// to the project-owned Python/drawsvg drawing pipeline.
//
// Keep this file self-contained. It must not introduce a runtime dependency on
// a second OpenSCAD drawing/dimension library. New composed sheets belong in
// dsg/drawing and use drawsvg for annotations/layout.

TD_DIMENSION_WIDTH = 0.06;
TD_DIMENSION_TEXT_SIZE = 0.42;
TD_DIMENSION_ARROW_LENGTH = 0.55;
TD_DIMENSION_ARROW_HALF_WIDTH = 0.18;

TD_SHEET_WIDTH = 190;
TD_SHEET_HEIGHT = 125;
TD_BORDER = 0.25;
TD_EXTENSION_WIDTH = 0.03;
TD_OUTLINE_WIDTH = 0.035;

module td_outline(width = TD_OUTLINE_WIDTH) {
    difference() {
        offset(delta = width / 2)
            children();
        offset(delta = -width / 2)
            children();
    }
}

module td_line_h(x0, x1, y, width = 0.18) {
    translate([min(x0, x1), y - width / 2])
        square([abs(x1 - x0), width]);
}

module td_line_v(x, y0, y1, width = 0.18) {
    translate([x - width / 2, min(y0, y1)])
        square([width, abs(y1 - y0)]);
}

module td_frame(
    title,
    subtitle = "",
    scale_text = "NTS",
    sheet_width = TD_SHEET_WIDTH,
    sheet_height = TD_SHEET_HEIGHT
) {
    difference() {
        square([sheet_width, sheet_height]);
        translate([TD_BORDER, TD_BORDER])
            square([
                sheet_width - 2 * TD_BORDER,
                sheet_height - 2 * TD_BORDER
            ]);
    }

    td_line_h(0, sheet_width, 18);
    td_line_v(sheet_width - 72, 0, 18);
    td_line_v(sheet_width - 34, 0, 18);
    td_line_h(sheet_width - 72, sheet_width, 9);

    translate([4, 10])
        text(title, size = 4.0);
    translate([4, 4])
        text(subtitle, size = 2.5);

    translate([sheet_width - 69, 11])
        text("SCALE", size = 2.2);
    translate([sheet_width - 69, 4])
        text(scale_text, size = 3.2);

    translate([sheet_width - 31, 11])
        text("UNITS", size = 2.2);
    translate([sheet_width - 31, 4])
        text("mm", size = 3.2);

    children();
}

module td_extension_v(x, y0, y1) {
    translate([x - TD_EXTENSION_WIDTH / 2, min(y0, y1)])
        square([TD_EXTENSION_WIDTH, abs(y1 - y0)]);
}

module td_extension_h(x0, x1, y) {
    translate([min(x0, x1), y - TD_EXTENSION_WIDTH / 2])
        square([abs(x1 - x0), TD_EXTENSION_WIDTH]);
}

module _td_arrow_h(x, y, direction) {
    polygon([
        [x, y],
        [x + direction * TD_DIMENSION_ARROW_LENGTH, y - TD_DIMENSION_ARROW_HALF_WIDTH],
        [x + direction * TD_DIMENSION_ARROW_LENGTH, y + TD_DIMENSION_ARROW_HALF_WIDTH]
    ]);
}

module _td_arrow_v(x, y, direction) {
    polygon([
        [x, y],
        [x - TD_DIMENSION_ARROW_HALF_WIDTH, y + direction * TD_DIMENSION_ARROW_LENGTH],
        [x + TD_DIMENSION_ARROW_HALF_WIDTH, y + direction * TD_DIMENSION_ARROW_LENGTH]
    ]);
}

module td_dimension_h(x0, x1, y, extension_from_y) {
    left = min(x0, x1);
    right = max(x0, x1);
    label = str(abs(x1 - x0));

    td_extension_v(left, extension_from_y, y);
    td_extension_v(right, extension_from_y, y);
    td_line_h(left, right, y, TD_DIMENSION_WIDTH);

    _td_arrow_h(left, y, 1);
    _td_arrow_h(right, y, -1);

    translate([(left + right) / 2, y + 0.18])
        text(
            label,
            size = TD_DIMENSION_TEXT_SIZE,
            halign = "center",
            valign = "bottom"
        );
}

module td_dimension_v(y0, y1, x, extension_from_x) {
    bottom = min(y0, y1);
    top = max(y0, y1);
    label = str(abs(y1 - y0));

    td_extension_h(extension_from_x, x, bottom);
    td_extension_h(extension_from_x, x, top);
    td_line_v(x, bottom, top, TD_DIMENSION_WIDTH);

    _td_arrow_v(x, bottom, 1);
    _td_arrow_v(x, top, -1);

    translate([x + 0.18, (bottom + top) / 2])
        rotate([0, 0, 90])
            text(
                label,
                size = TD_DIMENSION_TEXT_SIZE,
                halign = "center",
                valign = "bottom"
            );
}

// Retained only for compatibility with any not-yet-migrated local sheet.
// New angle annotations belong in the Python/drawsvg layer.
module td_angle(
    origin,
    start_rotation,
    angle,
    radius = 0.75,
    label_rotation = 0,
    label_offset = 0.35
) {
    translate(origin)
        rotate([0, 0, label_rotation])
            translate([radius + label_offset, 0])
                text(
                    str(angle, "°"),
                    size = TD_DIMENSION_TEXT_SIZE,
                    halign = "center"
                );
}


TD_A4_WIDTH = 297;
TD_A4_HEIGHT = 210;
TD_A4_MARGIN = 10;

module td_a4_landscape(
    title,
    drawing_no = "",
    scale_text = "NTS"
) {
    difference() {
        square([TD_A4_WIDTH, TD_A4_HEIGHT]);
        translate([TD_A4_MARGIN, TD_A4_MARGIN])
            square([
                TD_A4_WIDTH - 2 * TD_A4_MARGIN,
                TD_A4_HEIGHT - 2 * TD_A4_MARGIN
            ]);
    }

    title_x = TD_A4_WIDTH - 112;
    title_y = TD_A4_MARGIN;
    title_w = 102;
    title_h = 24;

    td_line_h(title_x, title_x + title_w, title_y + title_h);
    td_line_v(title_x, title_y, title_y + title_h);
    td_line_v(title_x + title_w, title_y, title_y + title_h);
    td_line_h(title_x, title_x + title_w, title_y);
    td_line_v(title_x + 72, title_y, title_y + title_h);
    td_line_h(title_x + 72, title_x + title_w, title_y + 12);

    translate([title_x + 4, title_y + 14])
        text(title, size = 3.2);
    translate([title_x + 4, title_y + 5])
        text(drawing_no, size = 2.5);
    translate([title_x + 76, title_y + 16])
        text("SCALE", size = 2.0);
    translate([title_x + 76, title_y + 5])
        text(scale_text, size = 3.0);

    children();
}

module td_section_mark(x, y0, y1, label = "A") {
    td_line_v(x, y0, y1, 0.12);
    translate([x - 1.6, y1 + 2])
        text(label, size = 2.5);
    translate([x - 1.6, y0 - 5])
        text(label, size = 2.5);
}
