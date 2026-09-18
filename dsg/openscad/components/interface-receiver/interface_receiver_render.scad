// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced detachable-interface receiver.

include <BOSL2/std.scad>

$fn = 120;

use <interface_receiver.scad>

module interface_receiver_design(view = "final") {
    if (view == "plain")
        interface_receiver_build(false);
    else
        interface_receiver_build(true);
}

interface_receiver_design();
