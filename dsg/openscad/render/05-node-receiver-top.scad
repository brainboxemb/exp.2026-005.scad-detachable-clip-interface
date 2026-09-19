include <BOSL2/std.scad>

$fn = 120;
use <../components/node-receiver/node_receiver.scad>

$vpt=[0,0,2];
$vpr=[0,0,0];
$vpd=28;

// Orthographic control view of the functional geometry. Keep non-functional
// millimetre grooves out so the constant straight-edge profile is unambiguous.
color([0.68,0.70,0.74])
    node_receiver_build(false);
