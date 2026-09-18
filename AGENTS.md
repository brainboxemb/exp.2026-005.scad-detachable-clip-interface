# Repository agent guidance

Persistent guidance for work in
`exp.2026-005.scad-detachable-clip-interface`.

## Repository role

This repository owns the **experiment and evidence** for a detachable printed
attachment interface. It is not the production owner of HUB75 couplers and it is
not the upstream OpenGrid source owner.

The ownership split is:

```text
fork.andylevesque.quackworks
    external source / upstream provenance

        ↓ exact pinned revision

exp.2026-005.scad-detachable-clip-interface
    PoP fixtures / analysis / tests / evidence

        ↓ qualified interface contract

2026-009-01.cad.HUB75-display-frame
    eventual production integration
```

Generic SCAD build/publication behaviour belongs to the pinned
`tool.scad-project`. Generic dependency/Git behaviour belongs to
`tool.git-project`. Cross-project status and the PoP record belong to
`brainboxemb.meta`.

## Source boundary

The QuackWorks fork is pinned below `dsg/openscad/ext/quackworks`.

Do not modify vendored/submodule source from this repository. If an upstream
patch is genuinely required, keep that work explicit in the fork and update the
pin here separately.

The current source baseline is:

```text
brainboxemb/fork.andylevesque.quackworks
e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

Keep attribution/licensing provenance explicit. Studying or rendering an
upstream mechanism is not permission to silently copy its implementation into a
production component.

## Experiment method

Work from the smallest question.

For each meaningful step:

- make the fixed side and removable side explicit;
- show insertion/removal direction where it matters;
- distinguish locating surfaces from retention/flex features;
- generate focused PNG evidence;
- export separate printable STL parts when physical handling can answer a
  question that CAD cannot;
- retain exact dependency/source revisions with the evidence;
- add variants only when an earlier result exposes a concrete unresolved
  question.

Do not jump from OG-01 directly to a HUB75 production coupler.

## OG-01 boundary

OG-01 reproduces the selected upstream OpenGrid receiver + snap as a reference.

It may:
- pose upstream geometry;
- color/transparently render it;
- create exploded/section views;
- export the fixed and removable upstream parts separately.

It must not:
- simplify the snap;
- change retention geometry;
- introduce HUB75 panel or coupler geometry;
- claim physical retention from render evidence alone.

## Output

Early experiment steps treat PNG and STL as complementary evidence:

```text
PNG   understand geometry / assembly / section
STL   print / handle / measure / fit-check
```

Generated output belongs under `bld/` or published Build branches, not beside
source.

## Project tooling

This repository intentionally uses an OpenSCAD-only direct build. Do not switch
to SCons or add PythonSCAD unless the experiment exposes a concrete need.

Before changing workflow/publication behaviour, read the pinned
`tools/tool.scad-project/AGENTS.md`.


## Commit and CI discipline

Treat a branch update as a **CI boundary**, not as a file-save operation.

For one coherent, reviewable work unit:

1. inspect the relevant current files first;
2. prepare all related edits before advancing the branch;
3. re-read/check the complete changed set;
4. write the related files as **one commit** when the available Git tooling permits;
5. advance the branch once;
6. then let that commit's CI/render/evidence run complete and inspect the result before starting another CI-bound correction.

Do not create a separate commit for every file merely because the GitHub contents API makes that convenient. On an active CI branch this needlessly starts, supersedes or cancels workflow runs and makes evidence harder to follow.

When working through GitHub tools, prefer the Git data flow for multi-file changes:

```text
create blobs
    -> create one tree
    -> create one commit
    -> update the branch ref once
```

Keep the commit boundary meaningful. Separate commits are still appropriate when changes are genuinely independent review units, when a completed evidence point should remain individually traceable, or when a failing CI run reveals a new correction that could not reasonably have been validated before the push.

Before pushing a logical work unit, catch avoidable follow-up commits by checking naming, imports/includes, documentation links, generated-output entrypoints and other touched references together.

If one logical task spans multiple repositories, preserve ownership boundaries: make one coherent commit per affected repository rather than combining unrelated repository concerns or producing per-file commits in each repository.

Do not rewrite already-published history merely to repair an earlier overly granular sequence unless there is a separate reason to do so. Apply this discipline to subsequent work.
