// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced detachable-interface snap.

$fn = 120;

use <interface_snap.scad>

module interface_snap_design(view = "final") {
    if (view == "profile")
        interface_snap_profile();
    else if (view == "plain")
        interface_snap_build(false);
    else
        interface_snap_build(true);
}

interface_snap_design();
