include <BOSL2/std.scad>

$fn = 120;
use <../components/node-snap/node_snap.scad>

$vpt=[0,0,2.3];
$vpr=[68,0,35];
// Match the node receiver's visual scale in the primary gallery.
$vpd=40;

color([0.92,0.30,0.12])
    node_snap_build(true);
