# Changelog

Functional evolution of the detachable SCAD clip-interface PoP.

## Unreleased

### Changed

- Revalidate OG-01/OG-02 with minimal upstream parameter overrides: only required
  board dimensions, required snap placement arguments and `lite=true` for the
  Lite snap; remove the experiment-derived Lite Z assembly offset pending the
  regenerated reference evidence.

### Added

- Record the reduced receiver + snap phase digital qualification from run `35344807800`: exact rail/plate/snap
  STL envelopes, manifold exports, shared interface provenance and seated
  clearance/interference analysis.
- Add the reduced receiver + snap phase as an inside-out OpenGrid-Lite-derived interface with two fixed-side
  carriers: a 50 × 10 × 4 mm receiver rail and the same 50 mm receiver profile
  on a 50 × 20 × 6 mm plate; both use one open-ended 10 mm two-sided snap.
- Bootstrap the OpenSCAD-only direct-build experiment repository.
- Pin the QuackWorks fork at exact source
  `e0c1cb7ec78dd9e9a8476ed739bd3402074354f3`.
- Add OG-01 upstream reference assembled, exploded and section PNG entrypoints.
- Add separate OG-01 fixed-receiver and removable-snap STL entrypoints.
- Qualify OG-01 on run `35336131546`: all three PNG and two STL targets build
  without geometry errors, and both exported parts are manifold.
- Add OG-02 Full/Lite comparison, individual receiver/snap profile PNGs and
  1.0 mm profile-slice STLs, plus complete Lite receiver/snap STL exports.
- Qualify OG-02 on run `35338032630`: all comparison/profile PNG and STL
  targets build without geometry errors and all exported STL solids are
  manifold; select Lite as the primary reduction reference for the reduced receiver + snap phase.
