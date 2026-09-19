// Interactive OpenSCAD entrypoint for the node-interface PoP.
//
// Keep this file focused on selecting and posing already-defined experiment
// views. Geometry lives in the experiment libraries.

/* [View] */
design_view = 13; // [0:Full assembled, 1:Full receiver, 2:Full snap, 3:Full receiver profile, 4:Full snap profile, 5:Lite assembled, 6:Lite receiver, 7:Lite snap, 8:Lite receiver profile, 9:Lite snap profile, 10:Full vs Lite assembled, 11:Full vs Lite exploded, 12:Full vs Lite section, 13:Node interface assembled, 14:Node interface exploded, 15:Node interface retention section, 16:Node receiver, 17:Node snap, 18:Node rail vs plate examples, 19:Node receiver transition section, 20:Node snap wall profile]

/* [Node interface] */
node_receiver_example = 0; // [0:Rail 50x10x4, 1:Plate 50x20x6 + receiver]
node_show_mm_pattern = true;

/* [Profile] */
profile_plane = 1; // [0:Center / flex slot, 1:Solid / beside flex slot]

/* [Section inspection] */
section_axis = "None"; // [None,X,Y,Z]
section_position_mm = 0; // [-100:0.5:100]
section_depth_mm = 10; // [0.1:0.1:200]
section_direction = "Positive"; // [Positive,Negative]

/* [Quality] */
render_fn = 96;
$fn = render_fn;

include <lib/opengrid_reference.scad>
include <lib/node_interface.scad>

function _main_profile_view(view) =
    view == 3 || view == 4 || view == 8 || view == 9;

function _main_comparison_view(view) =
    view == 10 || view == 11 || view == 12;

function _main_exploded_view(view) =
    view == 11 || view == 14;

function _main_node_view(view) =
    view >= 13 && view <= 20;

function _main_node_section_view(view) =
    view == 15 || view == 19;

$vpt =
    _main_node_view(design_view)
        ? [0, 0,
            design_view == 18 ? 5 :
            node_receiver_example == 1 ? 8 : 2.5]
        : _main_comparison_view(design_view)
            ? [0, 0, _main_exploded_view(design_view) ? 9 : 3.4]
            : [0, 0, 2.5];

$vpr =
    design_view == 15 || design_view == 20
        ? [90, 0, 0]
        : design_view == 19
            ? [0, 0, 0]
            : _main_node_view(design_view)
                ? [68, 0, 28]
                : _main_profile_view(design_view)
                    ? [90, 0, 0]
                    : _main_comparison_view(design_view)
                        ? [68, 0, 28]
                        : [65, 0, 35];

$vpd =
    _main_node_view(design_view)
        ? (design_view == 15 ? 48 :
           design_view == 17 ? 46 :
           design_view == 18 ? 150 :
           120)
        : _main_profile_view(design_view)
            ? 70
            : _main_comparison_view(design_view)
                ? (_main_exploded_view(design_view) ? 142 : 122)
                : 82;

SECTION_CUTTER_SPAN_MM = 1000;

module _main_section_slice(
    axis = "None",
    position = 0,
    depth = 10,
    direction = "Positive"
) {
    // "depth" is the exact retained slice thickness from the section plane.
    d = max(depth, 0.1);
    s = SECTION_CUTTER_SPAN_MM;
    positive = direction == "Positive";

    if (axis == "X")
        translate([
            positive ? position : position - d,
            -s / 2,
            -s / 2
        ])
            cube([d, s, s]);
    else if (axis == "Y")
        translate([
            -s / 2,
            positive ? position : position - d,
            -s / 2
        ])
            cube([s, d, s]);
    else if (axis == "Z")
        translate([
            -s / 2,
            -s / 2,
            positive ? position : position - d
        ])
            cube([s, s, d]);
}

module _main_selected_view(view) {
    if (view == 0)
        opengrid_full_assembled();
    else if (view == 1)
        color([0.70, 0.72, 0.76])
            opengrid_full_receiver();
    else if (view == 2)
        color([0.90, 0.28, 0.14])
            opengrid_full_snap();
    else if (view == 3)
        color([0.70, 0.72, 0.76])
            if (profile_plane == 0)
                opengrid_full_receiver_profile();
            else
                opengrid_full_receiver_solid_profile();
    else if (view == 4)
        color([0.90, 0.28, 0.14])
            if (profile_plane == 0)
                opengrid_full_snap_profile();
            else
                opengrid_full_snap_solid_profile();
    else if (view == 5)
        opengrid_lite_assembled();
    else if (view == 6)
        color([0.70, 0.72, 0.76])
            opengrid_lite_receiver();
    else if (view == 7)
        color([0.90, 0.28, 0.14])
            opengrid_lite_snap();
    else if (view == 8)
        color([0.70, 0.72, 0.76])
            if (profile_plane == 0)
                opengrid_lite_receiver_profile();
            else
                opengrid_lite_receiver_solid_profile();
    else if (view == 9)
        color([0.90, 0.28, 0.14])
            if (profile_plane == 0)
                opengrid_lite_snap_profile();
            else
                opengrid_lite_snap_solid_profile();
    else if (view == 10)
        opengrid_comparison_assembled();
    else if (view == 11)
        opengrid_comparison_exploded();
    else if (view == 12)
        opengrid_comparison_section();
    else if (view == 13)
        node_example_assembled(
            node_receiver_example,
            mm_pattern = node_show_mm_pattern
        );
    else if (view == 14)
        node_example_exploded(
            node_receiver_example,
            mm_pattern = node_show_mm_pattern
        );
    else if (view == 15)
        node_retention_section(node_receiver_example);
    else if (view == 16)
        color([0.68, 0.70, 0.74])
            node_example_receiver(
                node_receiver_example,
                node_show_mm_pattern
            );
    else if (view == 17)
        color([0.92, 0.30, 0.12])
            node_snap(node_show_mm_pattern);
    else if (view == 18)
        node_examples_comparison(node_show_mm_pattern);
    else if (view == 19)
        node_transition_section(node_receiver_example);
    else if (view == 20)
        color([0.92, 0.30, 0.12])
            node_snap_retention_profile();
    else
        assert(false, str("Unsupported design_view: ", view));
}

module _main_inspected_view() {
    if (section_axis == "None")
        _main_selected_view(design_view);
    else
        intersection() {
            _main_selected_view(design_view);
            _main_section_slice(
                axis = section_axis,
                position = section_position_mm,
                depth = section_depth_mm,
                direction = section_direction
            );
        }
}

_main_inspected_view();
