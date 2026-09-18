include <BOSL2/std.scad>

$fn = 120;
use <../examples/receiver-rail/receiver_rail_example.scad>

$vpt=[0,0,2];
$vpr=[68,0,28];
$vpd=115;

color([0.68,0.70,0.74])
    receiver_rail_example(true);
