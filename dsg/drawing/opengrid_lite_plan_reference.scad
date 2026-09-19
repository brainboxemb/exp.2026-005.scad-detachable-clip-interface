// Independent OpenSCAD reference for the Python plan reconstruction.
//
// This file is validation evidence only.  The Python implementation must not
// read or derive its geometry from this SVG output.

include <../openscad/lib/opengrid_reference.scad>

projection(cut = false)
    opengrid_lite_receiver();
