include <BOSL2/std.scad>

$fn = 120;
use <../components/interface-snap/interface_snap.scad>

$vpt=[0,0,2.3];
$vpr=[68,0,35];
$vpd=48;

color([0.92,0.30,0.12])
    interface_snap_build(true);
