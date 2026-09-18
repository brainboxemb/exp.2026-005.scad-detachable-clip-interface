// File: og01_reference.scad
// Upstream OpenGrid receiver + removable snap reference fixture.
//
// This file deliberately poses upstream QuackWorks geometry without
// reimplementing or modifying its mating features.

include <BOSL2/std.scad>
use <../ext/quackworks/openGrid/openGrid.scad>
use <../ext/quackworks/openGrid/opengrid-snap.scad>

OG01_TILE_SIZE = 28;
OG01_TILE_THICKNESS = 6.8;
OG01_SNAP_SIZE = 24.8;
OG01_EXPLODED_Z = 14;

module og01_fixed_receiver() {
    openGrid(
        Board_Width = 1,
        Board_Height = 1,
        tileSize = OG01_TILE_SIZE,
        Tile_Thickness = OG01_TILE_THICKNESS,
        Screw_Mounting = "None",
        Chamfers = "None",
        Connector_Holes = false,
        anchor = BOT,
        spin = 0,
        orient = UP
    );
}

module og01_removable_snap(directional = false) {
    openGridSnap(
        lite = false,
        directional = directional,
        anchor = BOT,
        spin = 0,
        orient = UP
    );
}

module og01_reference_assembled(receiver_alpha = 0.55) {
    color([0.72, 0.74, 0.78, receiver_alpha])
        og01_fixed_receiver();

    color([0.90, 0.28, 0.14])
        og01_removable_snap();
}

module og01_reference_exploded() {
    color([0.72, 0.74, 0.78])
        og01_fixed_receiver();

    translate([0, 0, OG01_EXPLODED_Z])
        color([0.90, 0.28, 0.14])
            og01_removable_snap();
}

module _og01_section_volume() {
    translate([-40, -40, -1])
        cube([80, 40, 30]);
}

module og01_reference_section() {
    color([0.72, 0.74, 0.78])
        intersection() {
            og01_fixed_receiver();
            _og01_section_volume();
        }

    color([0.90, 0.28, 0.14])
        intersection() {
            og01_removable_snap();
            _og01_section_volume();
        }
}
