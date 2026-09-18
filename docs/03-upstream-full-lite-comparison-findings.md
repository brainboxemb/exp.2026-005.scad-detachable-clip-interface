# Full versus Lite OpenGrid reference findings

Status: **accepted as the Full/Lite comparison baseline**

Source under test:

```text
brainboxemb/fork.andylevesque.quackworks
e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

Qualified by PR run:

```text
35338032630
```

## Generated evidence

The generated filenames are user-facing and no longer depend on knowing the
internal OG/AT testcase codes.

Primary complete Lite reference parts:

- `01-opengrid-lite-receiver.png/.stl`;
- `02-opengrid-lite-snap.png/.stl`.

Lite reference sections/profiles are grouped in the `40-...` range. Full
baseline/reference evidence is grouped in the `50-...` range, and Full-versus-
Lite comparison evidence in the `60-...` range.

The profile STL files remain true 1.0 mm-thick slices. All generated reference
targets report `Status: NoError`; all STL exports report a manifold top-level
3D object.

The numeric prefix is an output-navigation aid only. The experiment phases are
named descriptively in the design record.

## Dimension relationship

The pinned source defines:

```text
                         Full       Lite
receiver height          6.8 mm     4.0 mm
snap height              6.8 mm     3.4 mm
snap footprint          24.8 mm    24.8 mm
```

### Receiver

`openGridLite()` is not a separately invented cell profile. It derives the
Lite receiver from the Full 6.8 mm OpenGrid geometry using the upper portion of
the Full tile.

The retained receiver height is 4.0 mm, so the lower 2.8 mm of the Full
receiver envelope is absent in Lite.

### Snap

`openGridSnap(lite=true)` keeps the same nominal 24.8 mm square footprint but
reduces the height from 6.8 mm to 3.4 mm.

The Lite branch changes the snap's vertical construction:

- the lower Full-height stage is omitted;
- the main core changes from 6.4 mm to 3.0 mm;
- the top layer remains 0.4 mm;
- the normal retention nubs move from the Full snap's 3.4 mm level to the Lite
  snap's lower edge;
- the compliant click-hole geometry becomes correspondingly shorter.

The Lite snap is therefore not merely a slicer-scaled Full snap. It is an
explicit upstream low-profile variant preserving the same basic footprint and
retention concept.

## Z-envelope relationship

Full receiver and Full snap are both 6.8 mm high.

Lite differs:

```text
receiver = 4.0 mm
basic/QuackWorks Lite snap = 3.4 mm
arithmetic difference = 0.6 mm
```

The earlier the Full/Lite comparison revision interpreted that difference as a top-flush 0.6 mm
assembly offset. PR #3 superseded that interpretation. The accepted upstream
reference now uses the upstream CENTER anchoring for both receiver and snap and
does not manufacture a seated Z offset from the arithmetic height difference.

The 3.4 mm value is not an accidental legacy artefact in this reference:
current official openGrid documentation still describes the basic Lite snap as
using 3.4 mm of the 4.0 mm Lite board thickness. Newer community snap families
may make a different thickness choice and should be identified by family rather
than treated as a silent replacement for this pinned reference.

## What remains common

Full and Lite retain the important high-level architecture:

- same 28 mm cell pitch;
- same approximately 24.8 mm snap footprint;
- fixed receiver surrounding a removable insert;
- local perimeter retention;
- compliant regions beside retention features;
- a top functional surface that can remain flush in the assembled state.

The difference is primarily how much vertical structure is required to realise
that relationship.

## Directional mode

Directional retention exists independently of the Full/Lite selection.

the Full/Lite comparison intentionally uses:

```text
directional = false
```

for both variants. Mixing directional behaviour into this comparison would add
a second variable before the basic Full/Lite height/profile question is settled.

## the reduced receiver + snap phase consequence

**Lite is the preferred first reference for the reduced receiver + snap phase.**

That does not mean the reduced receiver + snap phase should copy the 24.8 mm Lite snap. It means Lite is the
better reduction starting point because upstream already demonstrates that:

- the Full 6.8 mm vertical envelope is not essential to the attachment concept;
- the 24.8 mm locating footprint can coexist with a much shallower removable
  part;
- retention/compliance can live near the functional interface instead of
  requiring the complete Full depth.

the reduced receiver + snap phase should therefore begin from the Lite relationship and ask what can be
reduced further:

1. how much of the four-sided receiver is actually needed;
2. which opposing locating surfaces carry useful load;
3. how many retention nubs are necessary;
4. how much compliant length the removable part needs;
5. whether the fixed-side footprint can shrink significantly below 28 mm without
   making insertion/removal or printing worse.

Full remains the control/reference if reducing the Lite principle exposes a
feature whose purpose is unclear.

## Not established

the Full/Lite comparison still does not establish:

- physical insertion or removal force;
- fatigue;
- printer/material tolerance robustness;
- retention under HUB75 tube loads;
- the final fixed-side dimensions;
- whether directional retention will be useful.

Those remain later PoP questions.
