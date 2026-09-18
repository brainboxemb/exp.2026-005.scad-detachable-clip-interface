include <../lib/opengrid_reference.scad>

$vpt = [0, 0, 0];
$vpr = [65, 0, 35];
// Primary gallery framing: keep a small, consistent visual margin.
$vpd = 66;

color([0.70, 0.72, 0.76])
    opengrid_lite_receiver();
