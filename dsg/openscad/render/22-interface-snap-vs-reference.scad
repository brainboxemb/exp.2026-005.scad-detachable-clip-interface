// Side-by-side snap-wall profile comparison.
// Left: upstream QuackWorks OpenGrid Lite snap, positive-X wall only.
// Right: AT-01 removable snap, positive-X wall only.
// Both are rendered at true physical scale.

include <../lib/og02_full_lite_reference.scad>
include <../lib/detachable_clip_interface.scad>

COMPARE_GAP = 7;
PROFILE_Y = 1.0;

// Crop to the positive-X snap-wall area only.
module _positive_x_crop(x_min, x_max, z_min=-2, z_max=8) {
    intersection() {
        children();
        translate([x_min, -PROFILE_Y/2, z_min])
            cube([x_max-x_min, PROFILE_Y, z_max-z_min]);
    }
}

module opengrid_lite_wall_profile() {
    // Upstream Lite snap body is ~24.8 mm wide; isolate the +X wall/nub.
    _positive_x_crop(9.5, 13.5)
        og02_lite_snap_profile();
}

module at01_wall_profile() {
    // AT-01 +X wall/nub; outer edge is 7.1 mm from centre.
    _positive_x_crop(4.2, 7.4)
        detachable_clip_snap_retention_profile();
}

// Rebase each positive-X wall so its inner region is visually comparable.
translate([-6.5, 0, 0])
    color([0.68, 0.70, 0.74])
        translate([-9.5, 0, 0])
            opengrid_lite_wall_profile();

translate([6.5, 0, 0])
    color([0.92, 0.30, 0.12])
        translate([-4.2, 0, 0])
            at01_wall_profile();

$vpt=[0,0,1.8];
$vpr=[90,0,0];
$vpd=54;
