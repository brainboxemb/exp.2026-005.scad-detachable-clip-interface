// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Design-render adapter for the reduced node receiver.

include <BOSL2/std.scad>

$fn = 120;

/* [Design view] */
view = "final"; // [final,profile,profile-vs-extrusion,plain,pattern-cutters]

use <../../../design_support.scad>
use <../node_receiver.scad>

module node_receiver_design(view = "final") {
    design_bosl2_context() {
        existing = [0.56, 0.56, 0.56, 0.42];
        current = [0.88, 0.08, 0.06, 0.78];

        if (view == "profile") {
            color(current)
                node_receiver_design_profile();

        } else if (view == "profile-vs-extrusion") {
            color(current)
                node_receiver_design_profile_vs_extrusion();

        } else if (view == "plain") {
            color(current)
                node_receiver_design_plain();

        } else if (view == "pattern-cutters") {
            color(existing)
                node_receiver_design_plain();
            color(current)
                node_receiver_design_pattern_cutters();

        } else {
            node_receiver_build(true);
        }
    }
}
node_receiver_design(view = view);
