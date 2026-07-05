# Changelog

All notable changes to this extension will be documented in this file.

## [0.9.26] - 2026-07-05

### Added

- **General View: quick filters on the toolbar.** One icon chip per element category in the model (use cases, requirements, interfaces, ports, …) shows or hides that whole category — **parts always show**. Hidden categories take their relations with them, so the graph re-lays-out cleaner; the choice is remembered per view. (issue #156)

- **Grid View: Doc (specification) column.** The requirements table now shows each requirement's `doc` text right after its name, and the cell is editable in place — a multi-line editor (Shift+Enter for a newline) writes the `doc /* … */` member back to the source: edit to replace, fill an empty cell to add, clear to remove. (issue #144)

- **Grid View: Export produces CSV.** The toolbar's Export on the Grid View saves the table as CSV (Excel-compatible, in your displayed column order, satisfy/verify links and status included) instead of an SVG picture. The graphical views keep the SVG export. (issue #157)

### Changed

- **General View — Full mode is now a hub-centred radial graph.** The top-level part def sits in the middle and its related elements span outward in all directions on concentric rings shaped by the composition/usage structure, with every other relation overlaid; unrelated elements form their own clusters and unconnected singletons pack into a compact grid. The layout is computed instantly (no worker round-trip), so large models (e.g. sdv.sysml) load fast. Full mode draws **straight or curved** connectors only — a saved orthogonal style shows as curved there, and stays orthogonal on the other views/modes. (issue #155)

- **Grid View columns behave like a spreadsheet.** Every column keeps its own width — resizing one no longer squeezes the others — and a horizontal scrollbar appears when the columns outgrow the pane, like Excel. Rows carry a sticky row-number gutter, and the table gained column grid lines and zebra striping. Also fixes a bug that could flood the header with phantom empty columns. (issue #145)


## [0.9.25] - 2026-07-04

### Changed


- **General View — Tree mode is now a clean top-down tree.** Every relation is drawn from the **owner's bottom** edge down to the **owned element's top** edge (no more side connections), for every line style — the orthogonal style reads as an elbow-bus org-chart, straight/curved radiate downward. The Tree is **top-down only** now (the left-right layout option was removed, and the layout-direction buttons no longer appear in Tree mode). (issue #152)

- **Grid View has no grid/dots background.** The requirements table is a table, not a canvas, so the notebook-grid dot pattern behind it is gone. (issue #147)



## [0.9.24] - 2026-07-04

### Added

- **General View: composed parts now render as their own boxes** (Tree & Full modes). A part usage is drawn as a rounded box, its owner links to it with a **usage** arrow (filled diamond at the owner; open for a `ref` part), and the box links to its part **definition** with a dashed **«defined by»** edge — the standard SysML v2 definition/usage depiction. Group mode still shows definitions grouped by kind (the parts stay listed inside each definition). (issue #149)

### Changed

- **General View: the "composition" relation is now labelled "usage"** in Properties, the Browser-View outline, and the footer. (issue #148)

- **General View toolbar is mode-aware**: the display-mode selector (Group / Tree / Full) is now the first control; the connector line-style selector is hidden in **Group** mode (no relations are drawn), and the layout-direction selector is hidden in **Full** mode (the organic "cloud" ignores direction). (issue #150)

## [0.9.23] - 2026-07-04

### Added

- **General View: three display modes** on the toolbar (icon selector). **Group** — definitions grouped by kind into labelled containers, with no relations (the pure inventory). **Tree** — a container-less tree of the definitions wired by their **usage/composition** links, each owner centred over its parts (main definition on top, branching down or to the side). **Full** — a container-less graph/"cloud" showing **all** relations (usage/composition, the specialization family — subsetting/redefinition/reference-subsetting — satisfy, import, …), laid out organically so related definitions cluster.

- **Connector line-style selector on the toolbar** (orthogonal / straight / curved), next to the layout icons, on every graph view — a live, per-view override of the `sysml.preview.diagrams.lineStyle` setting. On the General View tree it also shapes the layout: **orthogonal** reads as a classic org-chart with an elbow bus, **straight/curved** as a radiating tree.

### Changed

- **Faster General View layout**: the grouped type-bands now lay out **concurrently** instead of one at a time, so a General View with many bands appears in a single layout pass instead of stalling band-by-band.


## [0.9.22] - 2026-07-04

### Added

- **General View** now lays each type-band out as a **tree**: connected definitions (specialization / typing / composition families) flow along the layout direction, and relationship lines route **around** definition boxes instead of behind them, so a dense model is far less congested.

- General View **type-bands are now resizable, auto-expanding containers** (like the Interconnection View's part frames): drag a band's edge to resize it, and it grows to fit definitions dragged into it — the definitions move with the band. Relationship lines that run inside a band are now **selectable and movable** (they were click-blocked before).

- General View now draws a view/viewpoint's **`expose`** members as dashed «expose» arrows to the elements the view renders, and **import** arrows point at the deepest element named on the canvas (`import A::B::C` links to `C`, not just package `A`).

- **Grid View columns can be resized and reordered**: drag a column header's right edge to resize it, or drag a header onto another to reorder; the chosen widths and order are remembered per view.

- The **Browser View / Properties toggles moved into the panels themselves** — an open panel has an in-header collapse button and a closed panel leaves a slim rail to reopen it, so the toggles no longer float over (or overlap) the diagram.

Changed

- Diagram node text that no longer fits after a resize is now **truncated with an ellipsis** (with the full text on hover) instead of spilling outside the shape.

- Removed the **bottom-up** layout direction from the diagram toolbar (only top-down and left-right remain).

- Connector lines are now **movable**: select a connector and drag the hollow dot on any segment to bend the line through a new waypoint; drag a waypoint to move it, double-click it to remove it (removing the last one restores the automatic route). Waypoints follow the active line style (orthogonal/straight/curved), keep both ends glued to their ports/parts, persist in the diagram side-car (never in the `.sysml` text), and are cleared by endpoint reconnects and the ⟲ Reset-layout button.

- General View now draws **usage membership as composition arrows**: a nested usage typed by a definition on the canvas renders as `[B]<>--a-->[A]` — filled diamond at the owner, arrow at the typing definition, labelled with the usage name (`ref` usages take an open diamond). Parameters and subject/actor/stakeholder members stay compartment-only. (Documented deviation from OMG 8.2.3.6, which keeps composition in compartments — the compartment rows remain too.)

- The full specialization family is now distinctly drawn: usage subsetting carries a `{subsets}` annotation, redefinition (`:>>`/`redefines`) draws its own edge annotated `{redefines}`, and reference subsetting (`::>`/`references`) draws as a dashed hollow-triangle edge.



## [0.9.21] - 2026-07-03

### Added

- The requirements table now has **one column per attribute** (collected across every requirement in the file — a requirement without the attribute shows an empty, editable cell that adds it when filled), and **Constraint, Satisfy, and Verify are separate columns**; Satisfy/Verify list their link pills and accept a part / verification case name to create a new link.

- General View now draws dependency relationships (`dependency from A to B`) as dashed «dependency» arrows from each client to each supplier.

- General View now shows `flow def`, `connector`, and `allocation def` as definition nodes; an `allocation … allocate a to b` declaration draws its «allocate» arrow.

- Variation/variant notation: a `variation` point banners as «variation …» with a ◇ marker and lists its variants in a compartment; a `variant` banners with a ◆ marker; a `= all` configuration appears in a variant-config compartment.

- Metadata badges: `#Tag` prefix metadata and `@Annotation` members now show in a `metadata` compartment; `#Tag`-prefixed elements that were previously missing from some diagrams now render.

- Invariant shorthand (`inv { … }`) now shows as an `invariants` constraint compartment row on its owning element.

- `doc`, `comment`, and `rep` body text now appears in hover cards, the outline detail, and General-View notes (previously only the locale/language was shown).

- Sequence View: event occurrences declared with `then event occurrence …` chains are now supported — messages dock on their `part.event` endpoints and are ordered top-to-bottom by the lifelines' event timelines (not by declaration order); free-standing events render as labelled marks at their temporal position.

- Sequence View: `occurrence def`/`occurrence` interactions (the canonical OMG sequence-modeling form) now anchor a Sequence View.

- Elements now list nested `items`, `occurrences`, `calcs`, and named `constraints` in their own compartments, and package-level constraint/calc/occurrence/item/attribute usages — which have no dedicated view — now render in the General View as usage boxes with a «definedBy» link to their definition.

- General View boxes now list **every feature inside the box**: ports and nested parts appear as `ports` / `parts` compartments alongside `attributes` (no port glyphs on General View boxes — glyph/label overlap is gone; the Interconnection View keeps drawing real boundary ports). A defs-only library still shows its full interface structure.

### Changed

- Diagram toolbar redesigned: consistent theme-colored icons (no more mixed emoji glyphs), a visible 3-way layout-direction control, compact icon buttons for rename/delete/reset with tooltips, and clearer active/disabled states.
- The Layout control is now **specific to each diagram**: the General View offers its two real options (type-bands as rows or as side-by-side columns), the flow views keep Top→Down / Left→Right / Bottom→Up, and the Sequence and Grid views show no direction buttons at all (they have no direction). On package overviews the control now also packs the behavior tiles (Left→Right = rows, Top→Down = stacked).
- The canvas grid adapts to the zoom level: when the small squares would shrink below legibility the grid steps up to the next coarser cell size (and fades the fine lines back in as you zoom in), so a zoomed-out diagram no longer sits on a dense mesh.
- The Browser View and Properties panel toggles now live as arrow icons on the canvas itself — upper-left and upper-right corner — instead of toolbar buttons, in both side and tab modes.

### Fixed

- Action Flow View package overviews load in a fraction of the time: the per-behavior tiles are now laid out concurrently instead of one after another (an 11-tile overview no longer stalls for many seconds), the diagram webview ships React's production build in a bundle a third of the size, and the diagram host fetches its language-server data in parallel.
- `doc` documentation now renders as a `doc` compartment inside its owning element (with the actual documentation text), instead of a detached comment note; only package-level docs remain notes. Requirement text is now readable inside the requirement box.
- Sequence View: messages no longer render as dashed "reply" arrows just because they run opposite to the previous message — only explicitly reply-named messages are dashed.
- Grid View now lists requirement **usages**, not only definitions — a requirements model captured as usages (e.g. the HSUV requirements) renders a full requirements table instead of an empty view.
- Enumeration values now all appear in the `enumerations` compartment: values written with a body (`enum red { … }`) and value-restriction values (`= 60.0`) were previously dropped or shown as blank rows.
- Interconnection View: a connector now stays glued to its port while the port is dragged along a part's edge (previously the line stayed behind and only snapped across on release).
- Interconnection View: dragging a port to a different side of its part no longer makes the connector vanish or cut straight through (behind) the part — the line follows the port around the corner and routes around its own part box.
- String literals now accept backslash escapes (`\"`, `\\`, `\n`, `\t`, …), so a quote can appear inside a string (`"she said \"hi\""`) without breaking the rest of the line.
- `#Tag`-prefixed parts/items/etc. were silently omitted from the Interconnection/Case views and compartments; they are now drawn.
- Exponentiation (`**`, `^`) is now right-associative, so `2 ** 3 ** 2` is `2 ** (3 ** 2)`.
- SEM008 self-containment no longer flags a cycle that only closes through an `abstract` feature/definition (filled in by a concrete subtype) or an `individual` composite feature (a reflexive occurrence-identity view, not a new nested instance); the remaining direct mandatory self-typed cases (which the OMG corpus itself authors to demonstrate legal recursive-type syntax) are now a warning instead of an error.
- RES007 no longer rejects a recursive import (`X::**`) whose root `X` is a part/item/… usage instead of a package — a usage that owns nested usages is a namespace too (e.g. `import vehicle::**;` where `part vehicle { part interior { … } }`).
- Qualified references through a `public import Ns::*;` re-export aggregator (`ISQ::TorqueValue`, `SysML::Usage`, …) now resolve — the precomputed library index only ever recorded a symbol under its *declaring* namespace, never the aggregator's; the index build now synthesizes those aliases, including transitively through a chain of aggregators. Fixed a related RES002 false-ambiguity: two qualified names reaching the *same* underlying declaration (one direct, one via an aggregator) no longer count as a conflict.

## 

## [0.9.20] - 2026-06-28

### Added

- Committed an OMG-release conformance corpus and a permanent test gate validating against it.
- A documented, single source of truth for how every diagram element looks and behaves; selected ports show a "+" connect glyph and dotted anchor points while connecting.
- Drop-target highlighting while dragging a connector onto a port.
- Connection anchor points appear on every element while reconnecting a connector endpoint.
- "Go to definition" from a usage now opens the General View on its definition.
- New setting `sysml.preview.diagrams.syncUsageToDef`: choose whether Interconnection View edits apply to the usage (default) or the definition.
- Every Interconnection View part is now uniformly resizable, including empty leaf parts.
- Browser View gained expand/collapse tree controls.
- Package-level diagrams: any package can now anchor a diagram aggregating its whole subtree, with nested/tiled views per behavior.
- Interconnection View gained a port-to-port click-to-connect gesture.
- Tag-driven release/beta publishing automation (GitHub Actions → VS Code Marketplace + Open VSX).
- 3D Geometry View: parts typed by a library shape (box/sphere/cylinder/cone/wedge/pyramid) now render as solids in an isometric scene.
- Canonical per-type icons now appear consistently across the Browser View, toolbox, and outline.
- Connectors and relationships are now selectable, deletable, and individually reconnectable on the diagram.
- A view-specific editing toolbox: one-click element insertion and two-click relationship drawing, per diagram kind.

### Changed

- New default views: the diagram preview now opens on the **General View**, the Case View draws the subject as a **system boundary box**, and Interconnection View structural edits **synchronize to the typed definition** — all three previously off by default (`sysml.preview.diagrams.defaultKind` / `showSubjectAsBoundaryBox` / `syncUsageToDef`).
- The toolbar **Layout** control now re-arranges every flow view (Top→Down / Left→Right / Bottom→Up); it previously had no effect on the Interconnection, Action Flow, and State Transition views (their direction was hard-coded). The Interconnection View now lays out **top-to-bottom by default**, like every other view, instead of left-to-right.
- Diagram layout and redraw are noticeably faster on large models (e.g. a big Action Flow View): the layered-layout effort is capped without visibly worse routing, and each connector reuses one shared node lookup per frame instead of rebuilding its own.
- Diagram connectors now draw **below** the parts (smart-routed around them) instead of on top; container part frames are lightly translucent so the wiring routed beneath them stays visible, while leaf parts keep an opaque, readable body.
- All diagram connection and selection dots — port handles, node side handles, lifeline dots, and connector endpoint reconnect dots — now share one consistent, smaller size; the port keeps its thicker highlighted square contour as the "this is a port" cue.
- A port now exposes exactly **two** connection/selection dots — one on its outer side (external connections) and one on its inner side (delegation into the part) — instead of four, so a connector always meets a port perpendicular to the part boundary.
- Action Flow View rebuilt on the same nested-frame model as the Interconnection View (performers nest as frames instead of flat swimlanes); fixes mis-rendering and lag on succession-less models.
- State Transition View: composite/parallel states now nest their sub-states as real, individually-drawn frames instead of a flat flagged node.
- Diagram canvas rebuilt on React Flow + elk.js, fixing two long-standing bugs: elements not always addable, and the canvas freezing under certain gestures.
- Diagram anchoring and view state (zoom, layout direction) are now stable across view switches and retargets.
- Package overviews (Action Flow / State Transition / Sequence) now lay out each behavior's tile independently instead of flattening everything onto one canvas.
- General View now shows definitions only; every other view shows usages only.
- Browser View is now a dedicated panel (not a primary canvas kind), toggleable alongside Properties in both side and tab mode.
- Auto-import on save no longer imports standard-library names (they're already implicitly in scope).
- The package-overview showcase model was rewritten as a technically correct, well-typed composition.
- `pnpm build` is dramatically faster on a warm checkout — unchanged build steps now skip automatically.

### Fixed

- Compound unit literals such as `[N*m]`, `[km/h]`, `[m/s**2]` are now recognized as unit expressions instead of raising a false "unknown unit" warning.
- The ambiguous-import diagnostic now correctly defaults to a warning, not an error, for overlapping wildcard imports in valid models.
- Action Flow View: `then merge/action/fork/join/send/accept` branches and guarded `if/else` successions now render as real flow nodes and labelled edges instead of being dropped or drawn as extra diamonds.
- State Transition View: a focused composite/parallel state now renders itself as the containing frame, so its parallel marker and child regions are visible; both `parallel state` and `state … parallel` spellings are recognized.
- Valid action-flow guards (`if guard then action;`) are no longer flagged as illegal syntax.
- Common unit aliases (`m/s²`, `mph`, `psi`, `arcmin`, …) are now recognized instead of raising "unknown unit".
- Connectors and edge labels no longer get visually washed out by translucent container frames in any view.
- Sequence messages now stay attached to their lifelines when a frame is dragged.
- Connectors now dock directly on the part / port / lifeline, and their two endpoint selection dots sit exactly on the line ends instead of floating outside the element. The connector's line, arrowhead, endpoint dots, and label are all computed from the element's real geometry (not React Flow's half-handle-offset handle position), so they meet the element exactly; the connect handles are then free to be comfortable interaction targets. Dragging an endpoint dot re-docks the connector; with `syncUsageToDef` on it moves to any element (model + diagram), with it off only a re-dock on the same element is honoured (diagram only).
- Interconnection View connectors now leave and enter a port **perpendicular** to the part boundary (a short stub, then a turn) and route between those stubs, so they meet ports square-on and no longer run flush alongside a part's side.
- A port's two connect dots now sit on its outer and inner edges (perpendicular to the part boundary), leaving the glyph centre clickable so the port itself is selectable; the small fixed-size control nodes (initial / final / decision / fork / …) are selectable again now that their connect handles sit just outside the glyph.
- Sequence messages no longer overshoot the target lifeline; transitions and successions now touch their states / actions instead of stopping a few pixels short.
- Hovering a port now highlights only the port under the pointer and reveals its connect dots, instead of lighting up every port on the part.
- Container part frames are translucent and leaf parts opaque, so connectors routed beneath the parts stay visible without washing out the part bodies; ports dock connectors precisely on all four sides, including delegation ports.
- Adding the first element to an empty "build from scratch" view no longer silently fails.
- Adding into a selected container part could write to the wrong owner; the Properties pane was blank for ports owned by a frame or boundary.
- A flaky CI performance gate on large diagrams now tolerates slow runners without weakening the underlying regression check.
- A recursive wildcard import (`import Pkg::**;`) wasn't bringing nested members into scope; find-references missed the source end of a shorthand flow; Grid View could attach a qualified `satisfy`/`verify` link to the wrong same-named requirement.
- Removed a stale doc line claiming lambda expressions, parallel state regions, and `accept … via …` were "not yet delivered".
- Port connection targets now show the same drop-target highlight parts already had, plus a "+" glyph distinguishing port handles from plain connector endpoints.
- Collapsed (compartment-view) parts can be dragged/resized again; removed a leftover box behind the +/− control.
- `message` flows no longer render as Interconnection View connectors (they belong to the Sequence View only).
- Inout port direction chevrons no longer overlap into an unreadable mark.
- Selected ports now create connectors via a drag-the-dot gesture, matching connector reconnection.
- Selecting a parent/container part or an Interconnection View connector now populates the Properties pane, with reveal-in-source and go-to-definition where applicable.
- Interconnection View ports are larger and easier to click; connectors now meet the port's visible edge instead of crossing through it.
- Interconnection View presentation (Internals vs. Compartments) is now a per-part toggle instead of one global switch.
- Large package diagrams stay responsive; the minimap no longer doubles the render cost.
- Interconnection View boundary ports are visible, draggable, and route without overlapping the part body.
- Diagram rename can no longer produce invalid syntax; brace-less inline action bodies now render in the Action Flow View.
- The language server no longer freezes for several minutes on a misplaced declaration modifier (e.g. `part abstract def X;`).

## [0.9.1 – 0.9.11] - 2026-06-16 – 2026-06-20

Rapid interim Marketplace builds during active development of the diagram-preview subsystem (Geometry View, Interconnection View compartment/boundary presentations, usage-to-definition sync setting). Superseded in full by the [0.9.20] rebuild above - changes are not itemized separately here.



## [0.9.0] - 2026-06-07

### Added

- Project config file (`.vscode/sysml/project.json`) for project-scoped extension settings, including diagram setting overrides.
- Diagram tab mode: a full-tab editing surface with toolbar, outline, properties inspector, minimap, and footer status strip.
- Diagram preview: six SysML v2 graphical views (General, Interconnection, Action Flow, State Transition, Sequence, Case) rendered live from the model, no PlantUML.
- `.kpar` archive open/extract, and JSON abstract-syntax import/export.
- Auto-import on save: missing cross-package imports are inserted automatically.
- `.kpar` archive support for the bundled/external standard library path.
- A single source of truth for the element-category taxonomy, used consistently by completion, symbol search, and the outline.
- SysML v1 → v2 migration guardrail: v1 keywords and stereotypes are flagged with a one-click v2 rewrite.
- A server-backed AI agent tool surface (context, draft validation, library/unit search, symbol resolution, requirement traceability, diagnostic explanations) for use by VS Code AI agents — no bundled chat assistant or telemetry.
- Signature help for calc/constraint/function/action/predicate invocations.
- Inline completion (ghost text) for skeletal bodies, missing requirement subjects, package imports, and state-transition targets.
- Complete KerML well-formedness diagnostic family (KSM001–011), guarded by a semantic corpus gate.
- Full parser and semantic diagnostic catalogues for lexical, syntax, name-resolution, and KerML well-formedness checks, with matching quick-fixes.
- Filtered imports (`import Pkg::*[@Meta];`) and an import-cycle diagnostic.
- A whole-corpus formatter round-trip test guarding against silent model corruption on format.
- Real-time indexing feedback in the status bar, and eager parser warm-up at startup.
- `SysML: Report Parse Coverage` command.
- Cross-file rename, qualified-name aware scoping, and full cross-reference resolution (go-to-definition, find-references) across the workspace and bundled standard library.
- Full OMG-published standard library bundled and auto-indexed at startup.

### Changed

- Diagram view-state now persists in the repository (per-source-file side-car JSON under `.vscode/sysml/diagrams/`) instead of VS Code's opaque workspace storage.
- The bundled standard library is now served from a precomputed symbol index — completion/hover/go-to-definition into the library work immediately on a cold open, with no startup parsing.
- Large workspaces stay responsive: the editor-visible file is indexed first so hover/go-to-definition don't wait on the whole project.
- The language server now runs its parser in production mode, cutting startup from ~9 s to under a second.
- Converged the grammar onto the official OMG KerML/SysML textual BNF; the entire bundled standard library now parses.
- A single-pass grammar refactor unified how every declaration's typing/multiplicity/relationship clauses are structured, removing most parser ambiguity.
- Third-party project-manager integration removed from scope (not an OMG deliverable); `.kpar` archive support remains a tracked feature.

### Fixed

- Rename performance: a 50-reference cross-file rename now completes well under the half-second budget.
- A false "ambiguous import" warning when two standard-library packages appeared to define the same name.
- `part def` no longer gets corrupted into the invalid `partdef` when formatted.
- Hover and go-to-definition into the standard library now resolve correctly on first use.
- Several review findings: trivia-aware operator scanning, alias-aware satisfy/verify target resolution, wildcard-import visibility reporting, a safer "move to new file" refactor, and a corrected Getting Started walkthrough.

### Documented

- A canonical audit reconciled every requirement against the official OMG release, with spec citations.
- Stated explicitly that the extension collects no telemetry.

## [0.3.0] — 2026-05-10

### Added

- T-110/T-111: Rename (`prepareRename` + `rename`) — renames a named element and all in-file textual occurrences; cross-file deferred to T-072.
- T-112–T-116: Quick-fix code actions — add missing `;`, wrap unresolved name in `'…'`, convert `part def` ↔ `part`, add missing `subject` to requirement.
- T-120–T-122: AST-based formatter — 4-space indentation, one element per line, spaces around `:`, `:>`, `:>>`, `=`.
- T-124–T-125: Semantic token provider — distinguishes definition (class/interface/function) vs usage (variable/property/method) coloring.
- T-126–T-127: Inlay hint provider — shows `[1]` on usages without explicit multiplicity.
- T-128–T-129: CodeLens provider — "View references" on requirement defs; "Run verification" on verification case defs.
- T-130: Document highlight provider — highlights all textual occurrences of the name under the cursor.

## [0.2.0] — 2026-05-10

### Added

- T-070: Custom SysML name provider (extension point for `::` qualified-name resolution).
- T-071/T-080: Workspace symbol provider — powers Ctrl+T Go to Symbol in Workspace.
- T-091: Hover provider — shows element kind, name, typing, multiplicity, and doc comment in a markdown card.
- T-092–T-097: Completion provider — merges Langium defaults with SysML keyword and snippet completions.
- T-098: Snippet pack — `sysml-package`, `sysml-part-def`, `sysml-port-def`, `sysml-requirement`, `sysml-verification`, `sysml-state-machine`, `sysml-analysis-case`, `sysml-use-case`, `sysml-concern`.
- T-081/T-086/T-089: Semantic diagnostics — `SEM001` definition/usage name heuristic, `SEM005` constraint without body, `SEM006` requirement without subject, `SEM007` empty verification case hint.

## [0.1.0] — 2026-05-10

### Added

- TextMate syntax highlighting for `.sysml` and `.kerml` files (SysML v2 / KerML).
- Langium-based LSP parser for SysML Phase 1 subset: packages, imports, part/port/item/attribute/action/state/requirement/verification elements.
- Document outline (`textDocument/documentSymbol`) with hierarchical structure.
- Folding ranges for `{…}` bodies, block comments, and consecutive `import` groups.
- Workspace indexing with progress status bar item.
- Bundled minimal SysML standard library stubs (ScalarValues, ISQ, SI units).
- Language configuration: bracket pairs, comment toggling, autoclosing pairs.
- "SysML: Restart Language Server" command.
