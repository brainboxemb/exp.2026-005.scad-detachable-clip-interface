include <BOSL2/std.scad>

$fn = 120;
use <../examples/receiver-plate/receiver_plate_example.scad>

$vpt=[0,0,7];
$vpr=[68,0,28];
$vpd=120;

color([0.68,0.70,0.74])
    receiver_plate_example(true);
