include <BOSL2/std.scad>

$fn = 120;
use <../components/node-receiver/node_receiver.scad>

$vpt=[0,0,2];
$vpr=[0,0,0];
$vpd=28;

// Orthographic control view: the corrected receiver must keep a rectangular
// 10 x 10 mm plan without an hourglass top-guide transition.
color([0.68,0.70,0.74])
    node_receiver_build(true);
