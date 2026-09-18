// File: at01_inverted_core_snap.scad
// AT-01 — experiment-owned inverted fixed-core / removable-shell snap.
//
// This geometry does not copy the QuackWorks/OpenGrid snap. It keeps only the
// high-level design lessons: compact fixed side, removable compliant side,
// explicit locating/retention roles, and a Lite-like 4.0 / 3.4 mm Z baseline.

// Fixed-side baseline.
AT01_CORE_SIZE = 10.0;
AT01_CORE_HEIGHT = 4.0;
AT01_ROOT_SHOULDER = 0.6;
AT01_ENGAGEMENT_HEIGHT = 3.4;

// Removable shell.
AT01_CLEARANCE = 0.20;              // per side on nominal 10 x 10 core
AT01_SHELL_WALL = 1.20;
AT01_SHELL_TOP = 1.20;
AT01_SHELL_INNER = AT01_CORE_SIZE + 2 * AT01_CLEARANCE;
AT01_SHELL_OUTER = AT01_SHELL_INNER + 2 * AT01_SHELL_WALL;
AT01_SHELL_HEIGHT = AT01_ENGAGEMENT_HEIGHT + AT01_SHELL_TOP;

// Two-sided retention on +/-X.
AT01_RIB_PROTRUSION = 0.35;
AT01_RIB_WIDTH = 4.0;
AT01_RIB_Z_BOTTOM = 1.25;
AT01_RIB_Z_LOWER_MAX = 1.35;
AT01_RIB_Z_UPPER_MAX = 1.55;
AT01_RIB_Z_TOP = 2.05;

// Receiving window in each compliant shell tongue.
// Values are shell-local; assembled shell starts at Z=AT01_ROOT_SHOULDER.
AT01_WINDOW_WIDTH = 4.8;
AT01_WINDOW_Z_MIN = 0.60;
AT01_WINDOW_Z_MAX = 1.55;

// Two relief slots isolate the center tongue on each +/-X wall.
AT01_FLEX_SLOT_Y = 3.0;
AT01_FLEX_SLOT_WIDTH = 0.8;

// Evidence helpers.
AT01_EXPLODED_Z = 8.0;
AT01_PROFILE_SLICE = 1.0;

assert(
    abs(AT01_ROOT_SHOULDER + AT01_ENGAGEMENT_HEIGHT - AT01_CORE_HEIGHT) < 0.0001,
    "AT-01 Lite baseline must satisfy shoulder + engagement = 4.0 mm."
);
assert(
    abs(AT01_SHELL_INNER - (AT01_CORE_SIZE + 2 * AT01_CLEARANCE)) < 0.0001,
    "AT-01 shell inner size must preserve the stated side clearance."
);
assert(
    AT01_ROOT_SHOULDER + AT01_WINDOW_Z_MIN < AT01_RIB_Z_BOTTOM,
    "AT-01 seated window must start below the retention rib."
);
assert(
    AT01_ROOT_SHOULDER + AT01_WINDOW_Z_MAX > AT01_RIB_Z_TOP,
    "AT-01 seated window must end above the retention rib."
);
assert(
    AT01_RIB_PROTRUSION > AT01_CLEARANCE,
    "AT-01 retention rib must exceed nominal shell side clearance to create flex."
);

module _at01_positive_x_retention_rib() {
    // Polygon is defined in X/Z and extruded along Y.
    rotate([90, 0, 0])
        linear_extrude(height = AT01_RIB_WIDTH, center = true, convexity = 10)
            polygon(points = [
                [AT01_CORE_SIZE / 2, AT01_RIB_Z_BOTTOM],
                [AT01_CORE_SIZE / 2 + AT01_RIB_PROTRUSION, AT01_RIB_Z_LOWER_MAX],
                [AT01_CORE_SIZE / 2 + AT01_RIB_PROTRUSION, AT01_RIB_Z_UPPER_MAX],
                [AT01_CORE_SIZE / 2, AT01_RIB_Z_TOP]
            ]);
}

module at01_fixed_core() {
    union() {
        translate([-AT01_CORE_SIZE / 2, -AT01_CORE_SIZE / 2, 0])
            cube([AT01_CORE_SIZE, AT01_CORE_SIZE, AT01_CORE_HEIGHT]);

        _at01_positive_x_retention_rib();

        mirror([1, 0, 0])
            _at01_positive_x_retention_rib();
    }
}

module _at01_shell_outer() {
    translate([-AT01_SHELL_OUTER / 2, -AT01_SHELL_OUTER / 2, 0])
        cube([AT01_SHELL_OUTER, AT01_SHELL_OUTER, AT01_SHELL_HEIGHT]);
}

module _at01_shell_cavity() {
    // Ends exactly at the underside of the top plate.
    translate([-AT01_SHELL_INNER / 2, -AT01_SHELL_INNER / 2, -0.05])
        cube([AT01_SHELL_INNER, AT01_SHELL_INNER, AT01_ENGAGEMENT_HEIGHT + 0.05]);
}

module _at01_retention_window(x_sign = 1) {
    wall_center = (AT01_SHELL_INNER / 2 + AT01_SHELL_OUTER / 2) / 2;
    translate([
        x_sign * wall_center,
        0,
        (AT01_WINDOW_Z_MIN + AT01_WINDOW_Z_MAX) / 2
    ])
        cube([
            AT01_SHELL_WALL + 0.4,
            AT01_WINDOW_WIDTH,
            AT01_WINDOW_Z_MAX - AT01_WINDOW_Z_MIN
        ], center = true);
}

module _at01_flex_slot(x_sign = 1, y_sign = 1) {
    wall_center = (AT01_SHELL_INNER / 2 + AT01_SHELL_OUTER / 2) / 2;
    translate([
        x_sign * wall_center,
        y_sign * AT01_FLEX_SLOT_Y,
        AT01_ENGAGEMENT_HEIGHT / 2
    ])
        cube([
            AT01_SHELL_WALL + 0.4,
            AT01_FLEX_SLOT_WIDTH,
            AT01_ENGAGEMENT_HEIGHT + 0.10
        ], center = true);
}

module at01_removable_shell() {
    difference() {
        _at01_shell_outer();
        _at01_shell_cavity();

        for (x_sign = [-1, 1]) {
            _at01_retention_window(x_sign);

            for (y_sign = [-1, 1])
                _at01_flex_slot(x_sign, y_sign);
        }
    }
}

module at01_assembled(shell_alpha = 0.55) {
    color([0.68, 0.70, 0.74])
        at01_fixed_core();

    translate([0, 0, AT01_ROOT_SHOULDER])
        color([0.92, 0.30, 0.12, shell_alpha])
            at01_removable_shell();
}

module at01_exploded() {
    color([0.68, 0.70, 0.74])
        at01_fixed_core();

    translate([0, 0, AT01_ROOT_SHOULDER + AT01_EXPLODED_Z])
        color([0.92, 0.30, 0.12])
            at01_removable_shell();
}

module _at01_retention_slice_volume() {
    translate([-20, -AT01_PROFILE_SLICE / 2, -1])
        cube([40, AT01_PROFILE_SLICE, 12]);
}

module _at01_locating_slice_volume() {
    translate([-AT01_PROFILE_SLICE / 2, -20, -1])
        cube([AT01_PROFILE_SLICE, 40, 12]);
}

module at01_fixed_retention_profile() {
    intersection() {
        at01_fixed_core();
        _at01_retention_slice_volume();
    }
}

module at01_shell_retention_profile() {
    intersection() {
        at01_removable_shell();
        translate([0, 0, -AT01_ROOT_SHOULDER])
            _at01_retention_slice_volume();
    }
}

module at01_fixed_locating_profile() {
    intersection() {
        at01_fixed_core();
        _at01_locating_slice_volume();
    }
}

module at01_shell_locating_profile() {
    intersection() {
        at01_removable_shell();
        translate([0, 0, -AT01_ROOT_SHOULDER])
            _at01_locating_slice_volume();
    }
}

module at01_retention_section() {
    color([0.68, 0.70, 0.74])
        at01_fixed_retention_profile();

    translate([0, 0, AT01_ROOT_SHOULDER])
        color([0.92, 0.30, 0.12])
            at01_shell_retention_profile();
}

module at01_locating_section() {
    color([0.68, 0.70, 0.74])
        at01_fixed_locating_profile();

    translate([0, 0, AT01_ROOT_SHOULDER])
        color([0.92, 0.30, 0.12])
            at01_shell_locating_profile();
}
