# Aliot release captures

- Captured: 2026-09-27.
- Extension: 0.45.0 preview in VS Code.
- Themes: Aliot Light and Aliot Dark, captured independently through the theme picker.
- Model: [release-demo-before.sysml](https://github.com/voidaliot/sysml-v2-samples/blob/main/release-demo-before.sysml). The [after state](https://github.com/voidaliot/sysml-v2-samples/blob/main/release-demo-after.sysml) contains the local capacity override.
- View: Interconnection View, top-down layout, orthogonal connectors. The drone overview hides propulsion internals. The propulsion diagram shows the four motors and command connections.

These are genuine window captures. The only image processing is rectangular cropping and GIF encoding. No controls, labels, values or diagram geometry were drawn over the captures. The saved stills retain the capture tool's pointer highlight where visible.

Wide captures crop the extension webview at x=60, y=109, width=1810, height=865 from a 1873 by 1043 window capture. Properties crops use x=1337, y=151, width=530, height=823. This removes unrelated editor tabs, desktop and workspace status indicators. The port detail crop excludes a theme picker that was outside the Properties pane.

## Demonstrated behavior

- `v045-workspace-*`: Browser, drone diagram and battery Properties after a local override.
- `v045-properties-before-*`: capacity 80 inherited from Battery.
- `v045-properties-edit-*`: capacity 95 entered into the inherited field.
- `v045-properties-after-*`: applied local capacity override 95. nominalVoltage and mass stay inherited.
- `v045-properties-port-*`: powerOutput inspection, calculated direction, Conjugated control and directed voltage/current members.
- `v045-hierarchy-overview-*`: drone diagram with propulsion collapsed, with its Diagram pill visible in Browser.
- `v045-hierarchy-subsystem-*`: propulsion opened from that pill, with four connected motors and the Browser rooted at propulsion.

The property edit was made through Properties and verified in source as `attribute :>> capacity = 95;`. Battery's default stays 80 and spareBattery has no override. Both source snapshots validate without diagnostics. Start with the before state to repeat the edit.

The GIFs are still-image sequences. Properties holds before/edit/applied for 2.2/2.2/3.6 seconds. Hierarchy holds overview/subsystem for 3/4 seconds. They do not record cursor movement or show every intermediate UI operation. Up navigation was exercised and returns to the parent's General View; the looping hierarchy comparison shows the two IV states only.

To replace a GIF, record the same workflow in VS Code and save it with the existing asset name. Keep a still image beside it for reduced-motion viewing.

See [the media guide](../../MEDIA-GUIDE.md) for replacement and recording instructions.

## Existing Grid View capture

`grid-vscode.png` is an unchanged copy of the release repository image `assets/screenshots/feature-diagram-grid.png`. It shows the software-defined vehicle sample in VS Code, including the Requirements preset and Export CSV toolbar control. Its original capture date and extension version were not recorded here. The 0.45.0 provenance above does not apply to this image.

The same light capture is used in both website themes. The linked requirements CSV is separately generated from `aliot-all-views.sysml`; it is not the table shown in this screenshot.
