// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Experiment wrapper around the pinned QuackWorks/OpenGrid reference.
// Original OpenGrid design: David D.
// QuackWorks/OpenSCAD reference: AndyLevesque/QuackWorks,
// pinned at e0c1cb7ec78dd9e9a8476ed739bd3402074354f3.
// Third-party source retains its own notices; see LICENSE and
// docs/00-source-provenance.md.
//
// // File: og01_reference.scad
// Upstream OpenGrid receiver + removable snap reference fixture.
//
// Keep upstream defaults intact wherever possible. The board dimensions are the
// only required receiver inputs. openGridSnap() unfortunately requires BOSL2
// placement arguments without defaults, so those are supplied explicitly.

include <BOSL2/std.scad>
use <../ext/quackworks/openGrid/openGrid.scad>
use <../ext/quackworks/openGrid/opengrid-snap.scad>

OG01_EXPLODED_Z = 14;

module og01_fixed_receiver() {
    openGrid(
        Board_Width = 1,
        Board_Height = 1
    );
}

module og01_removable_snap() {
    openGridSnap(
        orient = UP,
        anchor = CENTER,
        spin = 0
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
    translate([-40, -40, -20])
        cube([80, 40, 40]);
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
