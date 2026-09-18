include <BOSL2/std.scad>

$fn = 120;
use <../components/node-receiver/node_receiver.scad>

$vpt=[0,0,2];
$vpr=[68,0,28];
$vpd=70;

color([0.68,0.70,0.74])
    node_receiver_build(true);
