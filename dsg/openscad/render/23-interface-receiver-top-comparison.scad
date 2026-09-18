include <../lib/detachable_clip_interface.scad>

translate([-16, 0, 0])
    color([0.68, 0.70, 0.74])
        detachable_clip_example_receiver(0, true);

translate([16, 0, 0])
    color([0.68, 0.70, 0.74])
        detachable_clip_example_receiver(1, true);

$vpt = [0, 0, 5];
$vpr = [0, 0, 0];
$vpd = 135;
