// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Stage-1 interface specification plus stage-2 reference implementation views.

include <../lib/detachable_interface_spec.scad>
include <../lib/node_interface.scad>
use <../lib/technical_drawing.scad>
use <../design_support.scad>

module _source_profile_2d() {
    polygon(detachable_source_lite_profile_points());
}

module _contract_receiver_profile_2d() {
    polygon(detachable_interface_receiver_profile_points());
}

module _reference_snap_profile_2d() {
    projection(cut = false)
        rotate([-90, 0, 0])
            node_snap_retention_profile();
}

module _contract_section_model() {
    // Fixed-side contract boundary.
    td_outline()
        _contract_receiver_profile_2d();

    // Actual minimal reference snap section over the contract. Showing the
    // implementation here makes the mating relationship inspectable without
    // turning its support/top geometry into part of the interface contract.
    td_outline()
        _reference_snap_profile_2d();

    td_dimension_h(
        -DETACHABLE_INTERFACE_WIDTH / 2,
         DETACHABLE_INTERFACE_WIDTH / 2,
        -2.1,
        0
    );

    td_dimension_h(
        -detachable_interface_snap_inner_width() / 2,
         detachable_interface_snap_inner_width() / 2,
        -3.2,
        0
    );

    td_dimension_h(
        -detachable_interface_snap_nub_opening() / 2,
         detachable_interface_snap_nub_opening() / 2,
        -4.3,
        0.2
    );

    td_dimension_v(
        0,
        DETACHABLE_INTERFACE_HEIGHT,
        9.2,
        DETACHABLE_INTERFACE_WIDTH / 2
    );
}

module interface_contract_sheet() {
    td_frame(
        "DETACHABLE INTERFACE CONTRACT",
        "stage 1 - nominal mating geometry; reference implementation overlaid",
        "6:1"
    ) {
        translate([57, 55])
            scale([6, 6])
                _contract_section_model();

        translate([9, 104])
            text("NOMINAL BASELINE", size = 3.4);
        translate([9, 98])
            text("fixed-side envelope: 10 x 4 mm", size = 2.7);
        translate([9, 93])
            text("same-origin seating; 0.6 mm height difference is not an offset", size = 2.7);

        translate([116, 103])
            text("KEY MATING WIDTHS", size = 3.1);
        translate([116, 97])
            text("receiver capture  10.0", size = 2.6);
        translate([116, 92])
            text("snap inner       10.2", size = 2.6);
        translate([116, 87])
            text("nub opening       9.4", size = 2.6);
        translate([116, 82])
            text("nub protrusion     0.4 / side", size = 2.6);
    }
}

module _source_interpretation_model() {
    td_outline()
        _source_profile_2d();

    td_dimension_h(
        -DETACHABLE_SOURCE_CAPTURE_WIDTH / 2,
         DETACHABLE_SOURCE_CAPTURE_WIDTH / 2,
        -2.0,
        detachable_interface_ramp_top_z()
    );
    td_dimension_v(
        0,
        DETACHABLE_INTERFACE_HEIGHT,
        16.0,
        DETACHABLE_SOURCE_LOWER_WIDTH / 2
    );
}

module _reduced_contract_model() {
    td_outline()
        _contract_receiver_profile_2d();

    td_dimension_h(
        -DETACHABLE_INTERFACE_WIDTH / 2,
         DETACHABLE_INTERFACE_WIDTH / 2,
        -2.0,
        detachable_interface_ramp_top_z()
    );
    td_dimension_v(
        0,
        DETACHABLE_INTERFACE_HEIGHT,
        8.0,
        DETACHABLE_INTERFACE_WIDTH / 2
    );
}

module opengrid_translation_sheet() {
    td_frame(
        "OPENGRID -> DETACHABLE INTERFACE",
        "experiment interpretation of pinned source dimensions - not an upstream drawing",
        "mixed"
    ) {
        translate([44, 62])
            scale([3.2, 3.2])
                _source_interpretation_model();

        translate([143, 62])
            scale([5.8, 5.8])
                _reduced_contract_model();

        translate([16, 101])
            text("A - OpenGrid Lite fixed-edge profile", size = 3.0);
        translate([16, 96])
            text("interpretation from pinned QuackWorks dimensions", size = 2.4);

        translate([118, 101])
            text("B - reduced interface contract", size = 3.0);
        translate([118, 96])
            text("radial mirror / 10 mm target capture", size = 2.4);

        translate([78, 72])
            text("25.0 -> 10.0", size = 3.0);
        translate([76, 66])
            text("26.4 -> 8.6", size = 2.6);
        translate([76, 61])
            text("25.8 -> 9.2", size = 2.6);
        translate([75, 51])
            text("Z bands retained", size = 2.4);
        translate([76, 46])
            text("0 / 1.6 / 2.6 / 3.6 / 4.0", size = 2.2);
    }
}

module reference_implementation_overview() {
    design_bosl2_context() {
        translate([-9, 0, 0])
            color([0.70, 0.72, 0.76])
                detachable_interface_reference_receiver(true);

        translate([9, 0, 0])
            color([0.90, 0.28, 0.14])
                detachable_interface_reference_snap(true);
    }
}

module reference_implementation_sheet() {
    td_frame(
        "MINIMAL REFERENCE IMPLEMENTATION",
        "stage 2 - one receiver + one snap implementing the stage-1 contract",
        "5:1"
    ) {
        translate([49, 61])
            scale([5, 5]) {
                td_outline()
                    _contract_receiver_profile_2d();
                td_dimension_h(
                    -DETACHABLE_INTERFACE_WIDTH / 2,
                     DETACHABLE_INTERFACE_WIDTH / 2,
                    -2.2,
                    0
                );
            }

        translate([137, 61])
            scale([5, 5]) {
                td_outline()
                    _reference_snap_profile_2d();
                td_dimension_h(
                    -detachable_interface_snap_inner_width() / 2,
                     detachable_interface_snap_inner_width() / 2,
                    -2.2,
                    0
                );
            }

        translate([31, 98])
            text("MINIMAL RECEIVER", size = 3.2);
        translate([117, 98])
            text("MINIMAL SNAP", size = 3.2);
        translate([16, 24])
            text("Both parts are reference implementations. Their carrier geometry is deliberately excluded.", size = 2.5);
    }
}

module interface_specification_design(view = "overview") {
    if (view == "overview")
        reference_implementation_overview();
    else if (view == "interface-contract")
        interface_contract_sheet();
    else if (view == "opengrid-translation")
        opengrid_translation_sheet();
    else if (view == "reference-implementation")
        reference_implementation_sheet();
    else
        assert(false, str("unknown specification view: ", view));
}
