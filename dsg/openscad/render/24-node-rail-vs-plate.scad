include <../lib/node_interface.scad>

translate([-22, 0, 0])
    node_example_assembled(0, mm_pattern = true);

translate([22, 0, 0])
    node_example_assembled(1, mm_pattern = true);

$vpt=[0,0,5];
$vpr=[68,0,28];
$vpd=140;
