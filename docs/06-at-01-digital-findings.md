# AT-01 digital findings — rail and plate receivers

Status: **superseded geometry baseline — local receiver correction active in PR #4**

Qualified source head:

```text
bbd1ab4de21d9fb29251c1b874b40c585624ffda
```

Build run:

```text
35344807800
```

Pinned QuackWorks source:

```text
e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

## Generated complete-part STL envelopes

Measured from generated STL vertex bounds:

```text
receiver rail     10.0 × 50.0 × 4.0 mm
receiver plate    20.0 × 50.0 × 10.0 mm total
                  = 6.0 mm plate + 4.0 mm receiver
removable snap    14.2 × 10.0 × 4.6 mm
```

Profile STL envelopes:

```text
rail profile      10.0 × 1.0 × 4.0 mm
plate profile     20.0 × 1.0 × 10.0 mm
snap profile      14.2 × 1.0 × 4.6 mm
```

All six AT-01 STL exports report a manifold top-level 3D object and
`Status: NoError`.

## Shared interface check

Both concepts call the same local receiver profile and the same removable snap.
The plate concept only adds a 50 × 20 × 6 mm carrier below the receiver rail.
No plate-specific snap geometry exists.

## Seated static clearance

The mirrored OpenGrid relation gives:

```text
receiver capture width      10.0 mm
snap body opening           10.2 mm
nominal body clearance       0.1 mm per side

snap nub opening             9.4 mm
nub protrusion                0.4 mm per side
```

The snap is seated 0.6 mm above the local receiver base. Evaluating the mirrored
receiver ramp and mirrored nub wedge over their common Z interval gives a
minimum seated static side clearance of approximately **0.10 mm per side**.

During insertion the 9.4 mm nub opening must pass the 10.0 mm capture band,
creating up to approximately **0.30 mm temporary interference per side**. That
preserves the nominal 25.0 / 24.8 / 25.6 mm OpenGrid relationship under the
radial mirror.

This is a geometry check only. It does not prove a printed 10 mm snap can
elastically provide that motion without excessive force or damage.

## Render inspection

The generated evidence contains rail and plate assembled/exploded views,
retention sections, a rail-versus-plate comparison, both receivers individually
and the shared snap individually.

The two retention sections use the same X/Z mating geometry. The plate section
differs only by the 6 mm carrier below the receiver. The snap is open at both Y
ends and attaches locally over the continuous 50 mm receiver.

## Digitally established

- the two requested carrier directions exist;
- receiver dimensions match their intended envelopes;
- both use the same local receiver/snap interface;
- source-derived seated geometry has positive static clearance;
- all build/export geometry is manifold;
- build provenance pins the exact QuackWorks source.

## Still requires physical evidence

- whether 0.30 mm temporary interference per side is too stiff at this scale;
- whether the 2.0 mm side wall is appropriately flexible;
- whether the scaled click slot remains effective;
- insertion/removal force;
- fatigue;
- material choice;
- whether rail or plate carrier is preferable for HUB75 integration.

Do not promote the interface into production from digital evidence alone.


## Superseded by local receiver correction

The run above qualified the first rail/plate geometry, but that revision
incorrectly extended the receiver profile over the full 50 mm carrier length.

PR #4 now corrects both concepts to one local 10 × 10 mm receiver position with
a 6 mm active region and 2 mm sloped transition at each end. New digital findings must
be recorded from the regenerated output before AT-01 is accepted.
