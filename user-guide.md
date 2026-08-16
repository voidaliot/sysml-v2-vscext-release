# SysML v2 VS Code Extension — User Guide

This guide explains how to install and use the SysML v2 VS Code extension with the public [SysML v2 sample workspace](https://github.com/voidaliot/sysml-v2-samples).

## 1. Install

1. Install [SysML v2 from the Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=voidaliot.vscode-sysml-v2).
2. If you downloaded a standalone `.vsix` instead, run `Extensions: Install from VSIX...` in VS Code.
3. Open a folder that contains `.sysml`, `.kerml`, or `.kpar` files.
4. Open a `.sysml` file and wait for the status bar to show `SysML: ready`.

The extension runs locally. It does not require Java, PlantUML, a diagram server, telemetry, or a cloud account.

## 2. Open the sample workspace

Clone the public sample repository and open it as a VS Code workspace:

```bash
git clone https://github.com/voidaliot/sysml-v2-samples.git
code sysml-v2-samples
```

Start with [`e-mountainbike.sysml`](https://github.com/voidaliot/sysml-v2-samples/blob/main/e-mountainbike.sysml) for the broadest guided tour, or open [`sdv.sysml`](https://github.com/voidaliot/sysml-v2-samples/blob/main/sdv.sysml) for a larger software-defined vehicle architecture. The repository also includes smaller drone, flashlight, vehicle, cruise-ship, and robocopter models, plus [exported SVG diagrams and a Grid View CSV](https://github.com/voidaliot/sysml-v2-samples/tree/main/diagrams).

For the first tour:

1. Open `e-mountainbike.sysml` and wait for **SysML: ready**.
2. Use hover, go-to-definition, completion, the document outline, and the Problems panel to explore the textual model.
3. Run **SysML: Which Diagram?** and choose the question you want to answer.
4. Open General, Interconnection, Action Flow, State Transition, Sequence, Case, or Grid View as content permits.
5. Move a node or connector waypoint, then inspect `.vscode/sysml/diagrams/` to see the git-friendly layout sidecar.
6. Rename or add an element from the canvas and confirm that the guarded edit updates the `.sysml` source.

## 3. Core editor workflow

Use SysML and KerML files like code:

- Syntax highlighting works instantly for `.sysml` and `.kerml`.
- Completion offers keywords, snippets, visible symbols, library names, members, and units.
- Hover shows element kind, typing, multiplicity, documentation, and library-source links.
- Diagnostics appear in Problems with stable codes such as `RES001`, `SEM006`, `UNIT003`, and `MIG001`.
- Quick fixes handle mechanical rewrites such as missing imports, boolean operator migration, missing requirement subjects, unit suggestions, and SysML v1 idiom migration.
- Formatting is AST-based and uses VS Code indentation settings.
- Go to definition, find references, rename, document symbols, workspace symbols, document highlight, signature help, and inlay hints are server-backed.

Useful commands:

| Command | Purpose |
|---|---|
| `SysML: Show Diagram` | Open the live diagram preview for the active model or element. |
| `SysML: Which Diagram? (view guidance)` | Pick the question you want answered and open the recommended view. |
| `SysML: Toggle Diagram Side / Tab Mode` | Switch between the side panel and full tab (`Ctrl+Alt+D`). |
| `SysML: Show Diagnostic Reference` | Open the diagnostic-code catalogue. |
| `SysML: Open Standard Library Folder` | Browse the bundled OMG standard-library source. |
| `SysML: Open .kpar Archive` | Open an OMG package archive as read-only extracted model files. |
| `SysML: Export Abstract Syntax JSON` | Export the active textual model to OMG abstract-syntax JSON. |

## 4. Diagram views

Run `SysML: Show Diagram` on `sdv.sysml`. The extension detects which views have content and offers the relevant options.

| View | Shows |
|---|---|
| General View | Definitions, packages, usage links, specialization, imports, requirements, metadata, variation, compartments, and quick category filters. |
| Interconnection View | Nested parts, ports, connectors, bindings, interfaces, item flows, endpoint docking, and reconnectable connectors. |
| Action Flow View | Actions, control nodes, send/accept nodes, item flows, final/terminate nodes, and performers. |
| State Transition View | States, composite and parallel state frames, transitions, guards, effects, exhibit and causation links. |
| Sequence View | Lifelines, activation bars, messages, payload labels, replies, and event occurrences. |
| Case View | Use, analysis, and verification cases with actors, subjects, includes, specialization, and optional boundary-box presentation. |
| Geometry View | 2D plan or isometric 3D shape layout from model-declared positions and dimensions. |
| Grid View | Editable requirements table with documentation, subject, per-attribute columns, constraints, satisfy/verify links, status, and CSV export. |
| Browser View | Package and membership tree panel with expand/collapse and diagram-element highlighting. |

Diagram colors follow the active VS Code theme. Layout state is stored under `.vscode/sysml/diagrams/` in the repository, not inside the `.sysml` source.

## 5. Edit diagrams safely

The diagram preview is not just a picture. It sends guarded workspace edits through the language server.

Common actions:

- Drag and resize nodes.
- Rename elements with `F2` or the toolbar action.
- Add view-specific elements from the toolbar tools.
- Draw relationships with two clicks: connect, transition, succession, message, include, satisfy, and other view-specific links.
- Select connectors, delete them, reconnect endpoints, or adjust waypoints.
- Export graph views as SVG.
- Export Grid View as CSV.

The text model remains authoritative. If an edit would produce invalid SysML, the server rejects it instead of corrupting the file.

## 6. Standard library

The complete OMG SysML v2 release standard library is bundled and pre-indexed:

- Systems Library: Parts, Ports, Items, Actions, States, Requirements, Constraints, Cases, Views, SysML.
- Kernel Libraries: data types, functions, and semantic kernel packages.
- Domain Libraries: Quantities and Units, Geometry, Analysis, Metadata, Cause and Effect, Requirement Derivation.

`sysml.standardLibraryPath` can point at an external `sysml.library/` source tree, a `.kpar` archive, or a directory of `.kpar` archives. Leave it empty to use the bundled library.

## 7. Recommended settings

Open VS Code settings and search for `sysml`.

| Setting | Default | Purpose |
|---|---:|---|
| `sysml.editor.autoImportOnSave` | `true` | Add missing cross-package imports on save. |
| `sysml.diagnostics.units` | `true` | Enable quantity and unit diagnostics. |
| `sysml.inlayHints.dimension` | `false` | Show physical-dimension hints. |
| `sysml.preview.diagrams.defaultKind` | `gv` | Preferred primary diagram view. |
| `sysml.preview.diagrams.defaultMode` | `side` | Open diagrams in side panel or tab mode. |
| `sysml.preview.diagrams.update` | `on-save` | Choose live, on-save, or manual diagram refresh. |
| `sysml.preview.diagrams.lineStyle` | `orthogonal` | Default connector routing style. |
| `sysml.preview.diagrams.syncUsageToDef` | `true` | Let IV structural edits synchronize to typed definitions. |
| `sysml.validation.severities` | `{}` | Override individual diagnostic severities. |

Project teams can check in `.vscode/sysml/project.json` to set diagram defaults consistently for a repository.

## 8. Troubleshooting

If the language identifier is not `SysML`, confirm the file extension is `.sysml` and select the language manually from the VS Code status bar.

If diagnostics look stale, run `SysML: Restart Language Server`.

If a diagram view is missing, the active model or selected anchor probably has no content for that view. Run `SysML: Which Diagram? (view guidance)` to choose the right view for your question.

If a standard-library symbol does not resolve, leave `sysml.standardLibraryPath` empty to use the bundled pre-indexed library, or verify that your external path points at a valid source tree or `.kpar` archive.

## 9. Links

- [Feature tour](https://voidaliot.github.io/sysml-v2-vscext-release/)
- [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=voidaliot.vscode-sysml-v2)
- [Public sample models](https://github.com/voidaliot/sysml-v2-samples)
- Issues: <https://github.com/voidaliot/sysml-v2-vscext-release/issues>
- Bundled library attribution: see the extension package `resources/sysml.library/` licenses.
