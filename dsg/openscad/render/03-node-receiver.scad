include <BOSL2/std.scad>

$fn = 120;
use <../components/node-receiver/node_receiver.scad>

$vpt=[0,0,2];
$vpr=[68,0,28];
// Compact 10 x 10 mm object: use most of the frame so the top guide is readable.
$vpd=34;

color([0.68,0.70,0.74])
    node_receiver_build(true);
