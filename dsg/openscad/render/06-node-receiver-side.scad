include <BOSL2/std.scad>

$fn = 120;
use <../components/node-receiver/node_receiver.scad>

$vpt=[0,0,2];
$vpr=[90,0,90];
$vpd=30;

// Orthographic Y-side control view: the top must stay level along Y; no
// V-shaped top profile or thin end fins are acceptable.
color([0.68,0.70,0.74])
    node_receiver_build(true);
