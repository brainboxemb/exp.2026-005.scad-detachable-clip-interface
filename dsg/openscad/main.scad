// Interactive OpenSCAD entrypoint for the detachable-clip PoP.
//
// Keep this file focused on selecting and posing already-defined experiment
// views. Geometry lives in the experiment libraries.

/* [View] */
design_view = 13; // [0:Full assembled, 1:Full receiver, 2:Full snap, 3:Full receiver profile, 4:Full snap profile, 5:Lite assembled, 6:Lite receiver, 7:Lite snap, 8:Lite receiver profile, 9:Lite snap profile, 10:Full vs Lite assembled, 11:Full vs Lite exploded, 12:Full vs Lite section, 13:Clip interface assembled, 14:Clip interface exploded, 15:Clip interface retention section, 16:Clip receiver, 17:Clip snap, 18:Clip rail vs plate examples, 19:Clip receiver transition section, 20:Clip snap wall profile]

/* [Detachable clip interface] */
clip_receiver_example = 0; // [0:Rail 50x10x4, 1:Plate 50x20x6 + receiver]
clip_show_mm_pattern = true;

/* [Profile] */
profile_plane = 1; // [0:Center / flex slot, 1:Solid / beside flex slot]

/* [Quality] */
render_fn = 96;
$fn = render_fn;

include <lib/og02_full_lite_reference.scad>
include <lib/detachable_clip_interface.scad>

function _main_profile_view(view) =
    view == 3 || view == 4 || view == 8 || view == 9;

function _main_comparison_view(view) =
    view == 10 || view == 11 || view == 12;

function _main_exploded_view(view) =
    view == 11 || view == 14;

function _main_clip_view(view) =
    view >= 13 && view <= 20;

function _main_clip_section_view(view) =
    view == 15 || view == 19;

$vpt =
    _main_clip_view(design_view)
        ? [0, 0,
            design_view == 18 ? 5 :
            clip_receiver_example == 1 ? 8 : 2.5]
        : _main_comparison_view(design_view)
            ? [0, 0, _main_exploded_view(design_view) ? 9 : 3.4]
            : [0, 0, 2.5];

$vpr =
    design_view == 15 || design_view == 20
        ? [90, 0, 0]
        : design_view == 19
            ? [0, 0, 0]
            : _main_clip_view(design_view)
                ? [68, 0, 28]
                : _main_profile_view(design_view)
                    ? [90, 0, 0]
                    : _main_comparison_view(design_view)
                        ? [68, 0, 28]
                        : [65, 0, 35];

$vpd =
    _main_clip_view(design_view)
        ? (design_view == 15 ? 48 :
           design_view == 17 ? 46 :
           design_view == 18 ? 150 :
           120)
        : _main_profile_view(design_view)
            ? 70
            : _main_comparison_view(design_view)
                ? (_main_exploded_view(design_view) ? 142 : 122)
                : 82;

module _main_selected_view(view) {
    if (view == 0)
        og02_full_assembled();
    else if (view == 1)
        color([0.70, 0.72, 0.76])
            og02_full_receiver();
    else if (view == 2)
        color([0.90, 0.28, 0.14])
            og02_full_snap();
    else if (view == 3)
        color([0.70, 0.72, 0.76])
            if (profile_plane == 0)
                og02_full_receiver_profile();
            else
                og02_full_receiver_solid_profile();
    else if (view == 4)
        color([0.90, 0.28, 0.14])
            if (profile_plane == 0)
                og02_full_snap_profile();
            else
                og02_full_snap_solid_profile();
    else if (view == 5)
        og02_lite_assembled();
    else if (view == 6)
        color([0.70, 0.72, 0.76])
            og02_lite_receiver();
    else if (view == 7)
        color([0.90, 0.28, 0.14])
            og02_lite_snap();
    else if (view == 8)
        color([0.70, 0.72, 0.76])
            if (profile_plane == 0)
                og02_lite_receiver_profile();
            else
                og02_lite_receiver_solid_profile();
    else if (view == 9)
        color([0.90, 0.28, 0.14])
            if (profile_plane == 0)
                og02_lite_snap_profile();
            else
                og02_lite_snap_solid_profile();
    else if (view == 10)
        og02_comparison_assembled();
    else if (view == 11)
        og02_comparison_exploded();
    else if (view == 12)
        og02_comparison_section();
    else if (view == 13)
        detachable_clip_example_assembled(
            clip_receiver_example,
            mm_pattern = clip_show_mm_pattern
        );
    else if (view == 14)
        detachable_clip_example_exploded(
            clip_receiver_example,
            mm_pattern = clip_show_mm_pattern
        );
    else if (view == 15)
        detachable_clip_retention_section(clip_receiver_example);
    else if (view == 16)
        color([0.68, 0.70, 0.74])
            detachable_clip_example_receiver(
                clip_receiver_example,
                clip_show_mm_pattern
            );
    else if (view == 17)
        color([0.92, 0.30, 0.12])
            detachable_clip_snap(clip_show_mm_pattern);
    else if (view == 18)
        detachable_clip_examples_comparison(clip_show_mm_pattern);
    else if (view == 19)
        detachable_clip_transition_section(clip_receiver_example);
    else if (view == 20)
        color([0.92, 0.30, 0.12])
            detachable_clip_snap_retention_profile();
    else
        assert(false, str("Unsupported design_view: ", view));
}

_main_selected_view(design_view);
