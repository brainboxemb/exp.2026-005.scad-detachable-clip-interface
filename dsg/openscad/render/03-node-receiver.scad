include <BOSL2/std.scad>

$fn = 120;
use <../components/node-receiver/node_receiver.scad>

$vpt=[0,0,2];
$vpr=[68,0,28];
// Small 10 x 14 mm object: frame it tightly enough to read the top guide.
$vpd=40;

color([0.68,0.70,0.74])
    node_receiver_build(true);
