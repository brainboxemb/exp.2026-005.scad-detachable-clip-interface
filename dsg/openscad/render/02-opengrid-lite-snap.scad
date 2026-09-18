include <../lib/opengrid_reference.scad>

$vpt = [0, 0, 0];
$vpr = [65, 0, 35];
// Primary gallery framing: keep a small, consistent visual margin.
$vpd = 62;

color([0.90, 0.28, 0.14])
    opengrid_lite_snap();
