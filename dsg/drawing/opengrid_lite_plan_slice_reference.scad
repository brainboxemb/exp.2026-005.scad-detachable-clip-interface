// Independent OpenSCAD horizontal-section oracle for the Python top view.
//
// Python derives every contour independently. This file only cuts the actual
// pinned OpenGrid Lite 3D model at a requested Lite-local Z height.
//
// openGridLite() is centred on Z=0 and is 4.0 mm high, so Lite-local Z 0..4
// maps to model Z -2..+2.

include <../openscad/lib/opengrid_reference.scad>

slice_z_mm = is_undef(slice_z_mm) ? 1.6 : slice_z_mm;

assert(slice_z_mm >= 0.0);
assert(slice_z_mm <= 4.0);

projection(cut = true)
    translate([0, 0, 2.0 - slice_z_mm])
        opengrid_lite_receiver();
