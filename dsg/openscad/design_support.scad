// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// Runtime context for design-documentation modules imported through OpenSCAD
// use<>. tool.scad-project intentionally generates design entrypoints with
// use<source>, so BOSL2's top-level special-variable defaults are otherwise
// not evaluated.

module design_bosl2_context() {
    let(
        $transform = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ],

        $tags = undef,
        $tag = "",
        $save_tag = undef,
        $tag_prefix = "",
        $tags_shown = "ALL",
        $tags_hidden = [],

        $overlap = 0,
        $color = "default",
        $save_color = undef,

        $anchor_override = undef,
        $attach_to = undef,
        $attach_alignment = undef,
        $change_anchors = undef,
        $attach_inside = false,

        $parent_anchor = [0, 0, -1],
        $parent_spin = 0,
        $parent_orient = [0, 0, 1],
        $parent_size = undef,
        $parent_geom = undef,
        $parent_parts = undef,

        $ghost_this = false,
        $ghost = false,
        $ghosting = false,
        $highlight_this = false,
        $highlight = false
    )
        children();
}
