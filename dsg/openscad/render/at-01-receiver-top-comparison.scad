include <../lib/at01_inverted_core_snap.scad>

translate([-16, 0, 0])
    color([0.68, 0.70, 0.74])
        at01_receiver(0, true);

translate([16, 0, 0])
    color([0.68, 0.70, 0.74])
        at01_receiver(1, true);

$vpt = [0, 0, 5];
$vpr = [0, 0, 0];
$vpd = 135;
