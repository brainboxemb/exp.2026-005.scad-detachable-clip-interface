include <../lib/opengrid_reference.scad>

$vpt = [0, 0, 0];
$vpr = [90, 0, 0];
$vpd = 58;

color([0.70, 0.72, 0.76])
    opengrid_lite_receiver_solid_profile();

color([0.90, 0.28, 0.14])
    opengrid_lite_snap_solid_profile();
