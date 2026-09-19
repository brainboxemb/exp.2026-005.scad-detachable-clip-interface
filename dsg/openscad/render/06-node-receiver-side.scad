include <BOSL2/std.scad>

$fn = 120;
use <../components/node-receiver/node_receiver.scad>

$vpt=[0,0,2];
$vpr=[90,0,90];
$vpd=30;

// Orthographic Y-side control view of the functional geometry. The X/Z
// profile must remain constant over the full 10 mm Y path.
color([0.68,0.70,0.74])
    node_receiver_build(false);
