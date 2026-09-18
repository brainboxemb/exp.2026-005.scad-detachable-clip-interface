include <BOSL2/std.scad>

$fn = 120;
use <../examples/receiver-plate/receiver_plate_assembled_example.scad>

$vpt=[0,0,8];
$vpr=[68,0,28];
$vpd=125;

receiver_plate_assembled_example(true);
