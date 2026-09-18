include <../lib/og02_full_lite_reference.scad>

$vpt = [0, 0, 0];
$vpr = [90, 0, 0];
$vpd = 58;

color([0.70, 0.72, 0.76])
    og02_lite_receiver_profile();

color([0.90, 0.28, 0.14])
    og02_lite_snap_profile();
