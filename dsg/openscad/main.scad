// Interactive OpenSCAD entrypoint for the detachable-clip PoP.
//
// Keep this file focused on selecting and posing already-defined experiment
// views. Geometry lives in the experiment libraries.

/* [View] */
design_view = 13; // [0:Full assembled, 1:Full receiver, 2:Full snap, 3:Full receiver profile, 4:Full snap profile, 5:Lite assembled, 6:Lite receiver, 7:Lite snap, 8:Lite receiver profile, 9:Lite snap profile, 10:Full vs Lite assembled, 11:Full vs Lite exploded, 12:Full vs Lite section, 13:AT-01 assembled, 14:AT-01 exploded, 15:AT-01 retention section, 16:AT-01 receiver, 17:AT-01 removable snap, 18:AT-01 rail vs plate]

/* [AT-01] */
at01_receiver_variant = 0; // [0:Rail 50x10x4, 1:Plate 50x20x6 + receiver]

/* [Profile] */
profile_plane = 0; // [0:Center / flex slot, 1:Solid / beside flex slot]

include <lib/og02_full_lite_reference.scad>
include <lib/at01_inverted_core_snap.scad>

function _main_profile_view(view) =
    view == 3 || view == 4 || view == 8 || view == 9;

function _main_comparison_view(view) =
    view == 10 || view == 11 || view == 12;

function _main_exploded_view(view) =
    view == 11 || view == 14;

function _main_at01_view(view) =
    view >= 13 && view <= 18;

function _main_at01_section_view(view) =
    view == 15;

$vpt =
    _main_at01_view(design_view)
        ? [0, 0,
            design_view == 18 ? 5 :
            at01_receiver_variant == 1 ? 8 : 2.5]
        : _main_comparison_view(design_view)
            ? [0, 0, _main_exploded_view(design_view) ? 9 : 3.4]
            : [0, 0, 2.5];

$vpr =
    design_view == 15
        ? [90, 0, 0]
        : _main_at01_view(design_view)
            ? [68, 0, 28]
                : _main_profile_view(design_view)
                    ? [90, 0, 0]
                    : _main_comparison_view(design_view)
                        ? [68, 0, 28]
                        : [65, 0, 35];

$vpd =
    _main_at01_view(design_view)
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
        at01_assembled(at01_receiver_variant);
    else if (view == 14)
        at01_exploded(at01_receiver_variant);
    else if (view == 15)
        at01_retention_section(at01_receiver_variant);
    else if (view == 16)
        color([0.68, 0.70, 0.74])
            at01_receiver(at01_receiver_variant);
    else if (view == 17)
        color([0.92, 0.30, 0.12])
            at01_removable_snap();
    else if (view == 18)
        at01_concepts_comparison();
    else
        assert(false, str("Unsupported design_view: ", view));
}

_main_selected_view(design_view);
