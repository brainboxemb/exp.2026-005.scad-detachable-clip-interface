include <../lib/node_interface.scad>

translate([-26, 0, 0])
    color([0.68, 0.70, 0.74])
        node_example_receiver(0, true);

translate([26, 0, 0])
    color([0.68, 0.70, 0.74])
        node_example_receiver(1, true);

$vpt = [0, 0, 5];
$vpr = [0, 0, 0];
$vpd = 135;
