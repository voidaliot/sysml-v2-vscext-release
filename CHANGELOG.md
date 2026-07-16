# Changelog

All notable changes to this extension will be documented in this file.

## [0.10.5] - 2026-07-16

### Fixed

- **Diagram links to a definition stay correct across files too.** Extending 0.10.4's fix: when a definition with the same name lives in **another file** of the workspace (or the standard library), drawing a feature-membership or defined-by link — or a relationship link written by name such as `satisfy`, `verify`, specialization, or dependency — now writes a qualified reference so it binds to the definition you clicked, not a same-named one elsewhere. Connector links (`connect`, `bind`, item flows, messages, transitions) keep their local part/port paths.

## [0.10.4] - 2026-07-15

### Changed

- **The General View's Group mode is clutter-free again.** Group no longer draws the package ownership links added in 0.10.2 — the type bands already show which package owns what. Group is the plain element inventory; switch to Tree to see ownership and every other relationship.
- **Dragging a link on the General View now reads both ends.** Drag from one definition to another to give the first a **feature membership** — a usage of the second (`part def Vehicle` → `part def Engine` adds `part engine : Engine;`). Drag from a usage to a definition for the **defined by** link, setting the usage's type — this previously refused with "that connection dot cannot target this element". Dragging between two usages still creates a redefinition, and specialization moved to the right-click menu. Both are offered in the right-click menu under the same names the diagram uses for those links.
- **A «defined by» link now reads "defined by" in Properties.** It previously showed the internal name (`definedBy`, badged `DEFINEDBY`).

### Fixed

- **Linking to a definition now always uses the one you clicked.** When two packages each declare a definition with the same name, drawing a feature-membership or defined-by link to one of them could silently bind to the other. The written type is now qualified (`P2::B`) whenever the plain name would be ambiguous.
- **Feature-membership links work on analysis and verification case definitions.** The gesture was refused on those two.
- **"Show all diagrams" appears on files without a package.** A file of bare `requirement def` / `attribute def` declarations was missing the lens even though the views can draw it.
- **Big diagrams stay responsive.** A 200-part model froze the General View tree and made new Interconnection connections take seconds to appear. Connector rendering no longer re-routes every line on every click or drag frame — while you drag a box, untouched connectors keep their route and settle once on release (crossing bridges reappear then too) — and adding a connection no longer re-runs automatic layout over the whole diagram: the new line simply appears, everything else stays put. Verified on a 495-element model with one definition used by 424 parts: dragging previously ran at ~3–7 fps because every box and line re-rendered on every frame; they are now skipped unless actually affected, and a line attached to the box you are dragging follows as a plain elbow until you release it.

### Added

- **"Show all diagrams" on the first line of every model file.** Opens the whole-file overview — every top-level package included — without having to reach for the editor title bar or the command palette. The per-element "Show diagram" lenses are unchanged and still open focused on their element.

## [0.10.3] - 2026-07-15

### Added

- **The requirements table shows an Id column.** Each requirement's declared identifier — its `reqId` attribute value, or its short name (`requirement <'REG-01'> …`) — now appears in an Id column right after the row number.
- **The requirements table nests sub-requirements.** A requirement declared inside another appears indented beneath it, and a parent row carries a chevron next to its name to collapse or expand its sub-requirements (to any depth).

## [0.10.2] - 2026-07-15

### Fixed

- **Relationship drag-to-create works again with the correct per-view defaults.** The 0.10.1 context-menu change accidentally hid and disabled the connection dots, leaving only Interconnection View port handles. General packages now set real package ownership (shown with circled-plus links to direct package members), definitions specialize definitions, usages redefine usages; Interconnection connects; Action Flow creates succession or pin flow; State Transition creates transitions; Sequence creates messages only between lifeline-line points; and Case creates includes. Geometry/Grid intentionally expose none, incompatible drops cancel, and right-click menus still choose the other relationship kinds.

## [0.10.1] - 2026-07-14

### Added

- **Sequence interactions warn when a reference participant does not select an actual occurrence.** `SSM014` flags a typed-only `ref part p : T;` when `p` is used as a message lifeline inside an `occurrence def`; bind it with `= context.actual` or redefine/subset an existing feature. The syntax remains valid elsewhere, so ordinary reference features and unused sequence scaffolds are not warned.

### Changed

- **Diagram creation has moved from the toolbar to focused right-click menus.** Right-click a blank surface to add an element to that diagram's exact model anchor, or right-click an element/port to choose a relationship valid from that source and then select a compatible target. Menus show the canonical icon and text, omit generic clipboard actions, and coexist with hover-visible drag-to-create connection dots; Interconnection View retains its specialized port handles. ([issue #81](https://github.com/voidaliot/sysml-v2-vsc-ext/issues/81))
- **Right-click add menus now match what each view and element can actually hold.** The blank-surface menu offers every element kind the view depicts at diagram level — Interconnection adds constraints/actions/states/calcs/occurrences alongside parts/ports/attributes/items, Action Flow and State Transition add their frame compartment rows, and the Grid View's choices follow the active preset (Requirements, Elements, Data, Matrix). Element menus offer only children that are semantically valid inside that element: an `enum def` offers enumeration values — never the view's generic list — and a Sequence View lifeline can add the `event occurrence` marks the view renders. Grid View table rows now open their own element context menu (rename, delete, add valid children) instead of the whole-table menu.
- **Context-menu relationships are drawn like port connectors.** Choosing a nameable relationship (transition, message) asks for the name first; then a live rubber-band line follows the pointer from the right-clicked element until you click the target to place the link (`Esc` cancels). No more name popup after the fact.

### Fixed

- **An escaped line break no longer hides an unterminated string or name.** A backslash at the end of a line inside a string literal or unrestricted name used to make the lexical scanner run on across the line break, losing the LEX001/LEX003 unterminated-literal report. The invalid escape (LEX004) and the unterminated literal are now both reported at the right place.
- **`SYN098` now reads the parsed model instead of the raw text.** A recovery-form `verify … by …` clause split across lines is now caught, and a member legitimately named `by` inside a verify statement no longer triggers a false error.
- **Clearing a value from the Data table works when a comment sits inside the value clause.** `attribute x = /* note */ 5;` now clears to `attribute x;` instead of silently failing the syntax guard.
- **Reset connector routing now has a simpler icon.** The crowded connector-plus-reset-arrow glyph is replaced by a clear orthogonal connector with two endpoints.
- **Bound `ref part` features now point to the actual part instead of duplicating it on the General View.** A binding such as `ref part driver = context.driver;` renders as an open-diamond link to the existing usage; only an unbound reference feature keeps a separate feature box. The SDV showcase sequences now bind every lifeline to its concrete participant in `demonstrationEcosystem`, matching the canonical OMG interaction examples.
- **`imports` background indexing now follows unrestricted package names and preserves import identity.** Opening a file such as the OMG training `Interface Example.sysml` now discovers and indexes its quoted `'Port Example'` import. After indexing, references and Go to Definition are relinked through that explicit import even if a same-named element in another package had already satisfied the permissive global fallback.
- **Remaining KerML feature and connector semantics are visible in diagrams.** Modifier-led and anonymous redefinition feature shorthands now appear in their owner's Features compartment; explicit subset and disjoint statements render as source-linked General View relationships; and binary/n-ary `connector` declarations plus complete `from … to …` end statements render in the Interconnection View using the existing connector/association-dot notation. Disjointness uses a neutral dashed `{disjoint}` line with no directional arrow. ([issue #80](https://github.com/voidaliot/sysml-v2-vsc-ext/issues/80))

## [0.10.0] - 2026-07-13

### Added

- **Grid matrices are separated by relationship type and table settings are isolated.** Matrix mode now requires a toolbar choice of Allocation, Dependency, Satisfy, Flow, or Connection; Interface and the unreadable combined matrix are not offered. Requirements, Elements, Data, and every Matrix family remember independent column order/width settings (legacy single-table settings migrate only to their former active view). Qualified model identities keep same-named elements in different namespaces distinct, and GRV is offered when any preset—not only Requirements—has content.
- **Elements and Data tables edit the model.** Elements supports Name, applicable Type/Multiplicity, and Doc edits while Kind stays read-only. Data supports Name, Type, and Value edits while Owner stays read-only. Double-click edits add, replace, or clear textual notation through the language server's syntax guard.

### Fixed

- **Imported definitions now contribute their structure to diagrams.** A typed part in one file now expands the parts, ports, connectors, pins, case structure, and geometry declared by its definition in another imported workspace or library file. In the OMG training Interface Example, `tankAssy` now shows its inherited `fuelTankPort`, `eng` shows its `engineFuelPort`, and the `FuelInterface` usage now draws the interface edge between those ports by following each `role ::> concrete.port` mapping, with navigation back to the Port Example definitions.
- **Case View no longer shows elements from another view.** Rapid view switches and live edits now discard older asynchronous diagram responses, so a late General View model cannot repaint a selected Case View with part/item/state definitions. Case View admits only case-family elements and subjects; its definitions toggle now includes standalone case definitions, uses an icon instead of a `defs` text button, and unnamed bound subjects no longer collide with their case node IDs.
- **Auto-import on save is now safe, scoped, and off by default.** Opting in no longer lets an import in one package suppress or redirect imports in a sibling, never adds a second same-named candidate when one is already imported, inserts the same needed import into every relevant namespace, preserves CRLF files, and persists ambiguity choices without racing the original save. `sysml.editor.autoImportOnSave` now defaults to `false`.
- **Empty diagrams are now editable — build a model from scratch on the canvas.** A view anchored on an element with no content for that kind (e.g. State Transition on a bare `part def`) now keeps that element as its anchor instead of reporting "No anchor element found": toolbox adds nest inside the anchored element and appear on the next render, so a valid SysML file can be grown entirely from an (initially empty) diagram. The view-kind selector still greys out contentless kinds, and an `occurrence def` still never anchors an Interconnection View. (issue #203)
- **`occurrence def` / `occurrence` offer the "Show diagram" CodeLens.** Occurrences are the OMG interaction containers, so they now carry the lens like parts/states/actions; an occurrence usage opens its natural Sequence View. (issue #204)
- **A part-anchored General View no longer includes unrelated package siblings.** A package-level relationship statement (`dependency from A to C;`) used to pull the whole package into the focused view; it now relates only its endpoints. A package-level `satisfy R by part;` now correctly relates the requirement to its satisfying part. (issue #205)
- **`ref` part membership uses the Release open diamond.** General View Tree now depicts a `ref part` as non-composite feature membership with an open owner diamond and a separate «defined by» edge, distinct from `::>` reference subsetting. Group mode keeps the single compartment row; Tree avoids duplication and does not recurse into elsewhere-owned ref contents. (issue #69)
- **N-ary dependencies use the Release hub notation.** Binary dependencies remain direct dashed open arrows; dependencies with multiple clients or suppliers now render one named central dot, arrowless client spokes, and open-arrow supplier spokes instead of a misleading clients×suppliers expansion. (issue #68)
- **Imports now require Release visibility.** An unqualified recovery-form `import` receives SYN067 and a preferred quick-fix to `private import`; snippets, auto-import fixes, hover examples, requirements, and acceptance guidance now always emit explicit visibility. Public re-export and protected-inheritance behavior is unchanged. (issue #66)
- **Textual output and diagnostics now follow the Release BNF.** Completions, snippets, refactorings, samples, and guides emit `analysis [def]` / `verification [def]`. Recovery-only `readonly`, `analysis case` / `verification case`, `verify … by …`, `.?field`, and bodyless `@Metadata` forms now receive targeted SYN018/SYN097/SYN098/SYN047/SYN075 errors instead of being presented as supported notation. (issue #63)
- **Names and strings use the exact KerML escape set.** LEX004 now rejects escapes outside Table 4 in both strings and unrestricted names; non-standard `\r`, `\v`, and `\0` handling is gone. (issue #65)
- **Constructor bodies now have the correct AST owner.** In `return feature x = new T(...) { ... }`, the body belongs to the return feature, matching KerML §8.2.5.8.3; `NewExpr` ends after its argument list. (issue #64)

## [0.9.38] - 2026-07-13

### Fixed

- **Interconnection View: connecting two ports no longer resets the canvas.** Dragging from one port to another to create a connector re-ran the automatic layout over the whole graph, visibly snapping every un-dragged part back to its computed position. Adding a connector now only draws the new edge; every existing node stays exactly where it was. (issue #50)
- **Interconnection View: the canvas can be panned from inside a part again.** Dragging on empty space inside a part moved the part instead of panning the canvas, so a large part with mostly-empty interior made the canvas hard to navigate. A part's drag-to-move gesture is now scoped to its keyword/name label; dragging anywhere else on it pans the canvas (a plain click still selects the part). (issue #58)
- **The read-only library boundary is actually enforced.** Renaming a symbol declared in the bundled (or a configured `standardLibraryPath`) library is now refused outright, and a workspace rename whose references happen to reach into a library file no longer proposes an edit to it. The bundled and any configured library tree are also marked read-only in the editor, so opening a library file (e.g. via go-to-definition) refuses direct edits. (issue #202)

## [0.9.37] - 2026-07-12

### Fixed

- **A handful more name-resolution false positives are gone.** A name lookup shared by several diagnostics (cyclic-specialization, private-import, dotted-namespace, and import-cycle checks) ignored which file a reference was written in, so a locally-declared name that happened to also exist elsewhere (a standard-library attribute, an unrelated file's usage of the same word) could resolve to the wrong element. Name resolution now prefers a declaration in the same file before falling back to the wider index. (issue #94)
- **`structure` is usable as an ordinary name again.** The grammar accepted `structure` as an undocumented alternate spelling of the KerML `struct` keyword, so any declaration or feature path segment named `structure` (`part structure : Structure;`) was misread as a keyword and rejected with a KerML-construct error. Only `struct` is reserved, per the OMG KerML grammar. (issue #1)

## [0.9.36] - 2026-07-12

### Added

- **Grid View has four table presets.** A toolbar selector switches the Grid View between the requirements table (the default), a plain element table (every named definition/usage with its kind, type, multiplicity and doc), a data-value table (attributes and value-carrying usages with their type, value and owner), and a relationship matrix (allocate / dependency / satisfy / flow / connect / interface links as a rows×columns matrix — an allocation matrix or interface control document). The presets are never mixed; the chosen one is remembered per view. (issue #122)
- **Every renderable relationship can be drawn from the canvas.** The link tools now cover the whole relationship family the views depict — specialization, redefinition, dependency, allocate, item flow, exhibit, perform, frame, verify and derive — in addition to connect/bind/succession/transition/message/satisfy/include. Each gesture inserts the matching textual statement (parser-guarded) and round-trips to the rendered edge. (issue #124)
- **Structured loops draw as frames.** A `while` / `loop until` / `for … in …` action renders in the Action Flow View as a labelled loop frame («while cond» / «loop» / «for x in …») containing its body actions, instead of a single node with the body flattened into the surrounding flow. (issue #123)
- **Sequence View combined fragments.** `if`/`alt`, `opt` and loop control structures inside an interaction render as labelled combined-fragment boxes (a corner tag plus guard/iteration condition) spanning the lifelines and temporal slots of the messages they contain. (issue #123)
- **Broader KerML kernel syntax parses.** The full OMG `kerml/src/examples` corpus (all 58 files, including the KerML Spec Annex A models) now parses. Newly accepted kernel constructs include short-name/`all` declaration headers (`class <'1'> A`, `type all x`), the named and bare relationship statements (`specialization Gen subtype A specializes B`, `inverse B::g of A::f`, `featuring F of y by C`), feature conjugation (`feature g ~ B::f`), n-ary and value connectors, the `$::` root-namespace qualifier, `member`-prefixed features, `all T` and `x.{ … }` expressions, prefix metadata before a member, and `inv` invariants with `rep` bodies. (issue #182)
- **Duplicate member names are diagnosed.** Two members of the same namespace that share a name or short name (or an `alias` that clashes with an owned member) are flagged with `RES017` — the confusing case that otherwise only surfaced later as arbitrary name resolution. Configurable via `sysml.validation.severities`. (issue #183)
- **Case View shows the typing case definitions.** Each rendered case usage's definition appears as its own oval («… def» banner, heavier outline) linked by dashed «defined by» lines; a toolbar `defs` toggle hides or shows them, remembered per view. (issue #197)
- **Case View adds usages from the toolbar.** The add tools now offer both the definition and the usage form of all four case families — use case, analysis, verification, and case. (issue #196)
- **Action Flow View action pins.** Named `in`/`out`/`inout` parameters—including parameters inherited by typed action usages—render as compact pins, and qualified item flows now dock on those pins instead of action centers. (issue #151)
- **Properties edits textual notation.** Rename sourced elements and named relationships, edit or clear a usage's Type and Multiplicity through visible keyboard-accessible controls, and choose or clear a port direction; every change is parser-guarded, written to the source, and reflected back into the diagram. (issue #142)
- **Browser View can focus on the current diagram.** A toggle beside the Browser filter hides model elements that are not available on the open view while retaining the ancestor branches needed to understand each visible element's containment path. (issue #137)

### Changed

- **Licence metadata is consistent.** The repository, extension manifest, packaged licence, and agent guidance now all identify the extension's custom Freeware License; the separately licensed OMG standard library retains its upstream terms. (issue #169)
- **General View Full mode lays out as an organic balloon tree.** Every element with feature members becomes the hub of its own small radial cloud: plain leaves sit right beside their owner while members that have their own descendants orbit farther out with their whole satellite cloud, growing the graph organically from the centre. Feature-membership relations drive the structure, boxes never overlap, and no membership line crosses an unrelated box. Loads instantly on large models. (issue #162)
- **General View Tree & Full modes show real def-usage-def structure.** Every named *composed* feature usage — parts, ports, attributes, items, states, actions, calcs, constraints, requirements, cases, views, connections, including nested ones — now draws as its own rounded usage box, linked from its owner by a feature-membership arrow (filled diamond) and to its definition by a dashed «defined by» line. The membership line never carries the usage name (it reads inside the box), and Tree/Full no longer render compartments — the Group mode keeps today's compartment inventory. (user direction 2026-07-10, with issue #154)
- **The "usage" relation is now called "feature membership".** Properties, the outline groups, and the footer use the OMG term for owner→feature links (renames the issue-#148 wording).
- **`ref` features are no longer drawn as usage boxes on the General View.** A `ref` references an element owned elsewhere rather than composing it, so the Tree/Full modes no longer depict it as an owned usage box (the earlier open-diamond «reference» box, its «defined by» edge, and the recursion into the ref's features are all dropped); only composed features shape the Tree. Group mode still lists the `ref` in its owner's compartment inventory. The Tree layout also gets a little more vertical spacing between levels.
- **The General View's Full mode is gone; Tree now carries every relation.** The General View has two display modes — Group and Tree. Tree renders *all* relations (feature membership, specialization/subsetting, satisfy, verify, import, …) while keeping its clean top-down layout, which is still shaped only by the part-composition hierarchy so the other relations overlay it without distorting the tree. A saved Full view opens as Tree.
- **Feature-membership boxes are shown for parts only.** In Tree mode only `part` usages draw as their own boxes (the def→usage→def reading); every other feature — ports, attributes, items, actions, states, calcs, constraints — reads the OMG-standard way as a compartment row on its owning box. A part box is kept lean: it omits the redundant `: Def` typing label (the «defined by» edge already shows the definition) and lists only its **local** attributes, since inherited attributes already appear on the definition box.

### Fixed

- **OMG reference models validate without ghost errors.** Relative, re-exported, inherited, and dotted names now resolve (`P1::B`, `Person::Life`, `system.uc1`); flow definitions are valid type targets; legal reference subsetting, owner-body metadata, KerML `featured by` Features, coordinate-frame/measurement-reference postfixes, local units, and Unicode unit exponents no longer raise false SYN/RES/KSM/UNIT errors. A new semantic corpus gate validates every committed OMG validation, examples, training, and KerML model at zero error diagnostics. (issue #184)

- **Interconnection View layout directions now describe the top level.** Top→Down stacks top-level parts vertically and Left→Right places them horizontally; the contents inside every part retain the established left-to-right flow in both modes. (user direction 2026-07-11)
- **Multiline notes (`//* … */`) are recognized.** The KerML `//* … */` note is now lexed as hidden trivia and highlighted as a foldable block comment, instead of the opening `//` swallowing the line and leaving the closing `*/` as stray code. Five OMG release examples that use this note form now parse. (issue #180)
- **Unrestricted names accept backslash escapes.** A single-quoted name may contain the KerML escapes `\'`, `\"`, `\t`, `\n`, `\\`, etc. (`part def 'A\'B';`), and names are compared by their decoded value, so references resolve regardless of how the escapes are written; renaming to a name with spaces or quotes writes a correctly-escaped token. (issue #181)
- **Properties no longer repeats feature memberships.** The Connections group omits feature-membership and «defined by» rows — the parts/attributes/… declarations and the Type property already show them; real connectors, flows, and specializations still list. (issue #154)
- **State Transition View transitions are created where you draw them.** The two-click transition tool (and the Action Flow "then" tool) now writes the statement into the element that owns both endpoints — the state machine or owning action — instead of the diagram anchor, where a package anchor used to strand it invisibly at package level. Transition and succession ends can also be reconnected by dragging, like connectors. (issues #199, #200)
- **Action Flow parallel arrows are individually selectable.** A succession and an item flow between the same two actions (or several guarded successions) used to render as exactly stacked lines where only the topmost was clickable; parallels now fan apart so each line can be hovered and selected on its own. (issue #200)
- **Fork and join bars follow the flow direction and resize freely.** Left→Right flows draw them as vertical bars, and the resize minimum no longer forces a 48×24 box — bars shrink down to a thin bar in either orientation. (issue #201)
- **State Transition View no longer draws the exhibiting part.** The redundant part-def box and its wrongly attached «exhibit» edge are gone — the state machine already names its owner, and exhibit/perform edges remain on the General View. (issue #198)
- **General View Tree line styles no longer move nodes.** Switching among orthogonal, straight, and curved redraws only the connectors and preserves the current layout; use the dedicated Reset control to explicitly re-run automatic layout. (issue #153)

- **Orthogonal connector crossings are unambiguous.** Interconnection and General View connectors show a small semicircular jump where one route crosses another; joins, bends, overlaps, and near-misses remain unmarked. The jump is drawn as a real gap-and-arc in the connector's own line — no background patch is painted, so the crossed connector and the canvas grid stay fully visible at every crossing. (issue #141)
- **Interconnection View port labels stay readable.** Port names now sit outside the owning part, beside rather than on the connector axis, and use an opaque theme-aware mask so connectors and part titles cannot obscure top, bottom, left, or right port labels. (issue #140)
- **Interconnection View edits stay local by default.** `sysml.preview.diagrams.syncUsageToDef` now defaults to `false`, as documented by REQ-364, so editing a typed usage no longer writes into an often-empty type definition unless synchronization is explicitly enabled. (issue #132)

### Removed

- **Dead performer-swimlane machinery.** The flat swimlane layout was superseded by nested performer frames in an earlier release and no longer produced any output; its unreachable code (the swimlane layout pass, the `lane`-metadata plumbing, and the profile flag) has been removed. The Action Flow and State Transition Views are unchanged — performers still render as nested frames. (issue #125)

## [0.9.35] - 2026-07-09

### Fixed

- **Delegation connectors now always show.** A connector from an internal part's port to a boundary port of the enclosing part (e.g. `connect wheels.spin to roadContact;`) could be missing from the Interconnection View even though it was correctly written in the model. Such a connector docks on the port's *inner* side, but the port only drew a handle on its outer side, so React Flow couldn't resolve the endpoint and silently dropped the whole edge. Every port now renders a connect handle on both its outer and inner sides, so the connector is always drawn. (issue #195)
- **Dropping a connector onto a port is reliable anywhere on it, and the line snaps to the connection point.** While you drag a connector, moving it over a port highlights the port and the preview line visibly snaps to the port's connection dot, so you can see exactly where it will land; releasing lands it anywhere on the port — inside the square or on any edge — with no pixel-perfect sweetspot, and a nearby part edge can no longer steal the drop. Ports stay fully selectable and movable (grab cursor on hover), and you still draw a connector by dragging from the port's connect dot, exactly as before. Where the connector docks is chosen automatically by whether it comes from inside or outside the part. (issue #195)

## [0.9.34] - 2026-07-09

### Added

- **Reset connector routing without disturbing the layout.** A new bottom-left control-bar button (beside Fit and Reset) snaps every connector line back to its automatic route while KEEPING the node/block positions and port placements you arranged. The existing Reset still returns everything to automatic layout. (issue #188)
- **Create named messages in the Sequence View.** Draw an arrow between two lifelines (or use the ✉ tool) and an inline text box immediately appears for the message name; on Enter the message is written into the owning `occurrence def`/part (`message <name> from a to b;`). Leaving the name blank creates an anonymous message. (issue #192)

### Fixed

- **Ports connect reliably in the Interconnection View, and land on the connection point.** Starting a connector from a port used to fail intermittently — the port-move grab area covered the connect dots, so a drag often slid the port instead of drawing a line; the move handle is now a thin strip that leaves the connect dot targetable. And a port now shows a single connect dot on its outer edge instead of two, so a dropped connector lands on that point on the part boundary rather than snapping to an "imaginary" point inside the port. (issue #187)
- **Right-click ▸ Rename works on Interconnection View parts.** A container part is drawn as a frame, and Rename/Delete previously only recognised leaf nodes, so the menu items did nothing on any part with internals. The frame's title is now editable in place — right-click ▸ Rename (or F2), type, Enter. (issue #189)
- **Ports are much easier to connect.** Dropping (or starting) a connector no longer needs a pixel-perfect sweetspot: the port's connect handle has a larger invisible hit area and a more forgiving snap radius, and in the Interconnection View a ported part connects only through its ports (its body no longer competes for the drop), so a drop anywhere near the port lands on it and the port highlights as the drop target. (issue #190)
- **Sequence View `send` events are labelled.** A `send DoorStatus() to …` message arrow now carries its payload/signal label (`DoorStatus`), like `message` arrows; previously send arrows were blank. (issue #191)
- **Metadata annotations show their attribute values.** A named metadata usage (`metadata m : SafetyLevel { level = 3; }`) or a `@`-annotation (`@SafetyLevel { level = 3; }`) now displays its attribute value assignments — e.g. `SafetyLevel { level = 3 }` — on its diagram annotation node/badge, not just the bare metadata type name. (issue #121)

### Changed

- **Sequences are `occurrence def` interactions, shown in the Sequence View and kept out of the Interconnection View.** The Sequence View now anchors on an `occurrence def` — the canonical OMG interaction container — whose participants are `ref part` references, and such an interaction (and the parts it references) no longer appears as blocks in the Interconnection View. The bundled Software-Defined-Vehicle showcase's five sequences were re-modelled from standalone `part def`s accordingly. (issue #113)

## [0.9.33] - 2026-07-08

### Fixed

- **Connector end multiplicities are drawn on diagrams.** Declared end multiplicities (e.g. `connect [0..1] a to [1] b;`) now render at both ends of connect/binding/interface/typed-connection edges, matching the node-level `[N]` labels that already worked. Previously neither end of a connector ever showed its multiplicity, regardless of the source. (issue #120)

## [0.9.32] - 2026-07-07

### Security

- **Grid View CSV export no longer executes model-controlled formulas.** A requirement name, doc body, or attribute value beginning with `=`, `+`, `-`, `@`, TAB, or CR is now prefixed with `'` and force-quoted before export, so opening the exported `.csv` in Excel/LibreOffice/Sheets can no longer run an embedded formula or DDE payload from an untrusted model file. (issue #166)
- **`.kpar` extraction can no longer be used as a decompression bomb.** Archive entries are now checked against a per-entry and per-archive decompressed-size cap read from the zip central directory, and the actual `zlib` inflate call is capped independently (`maxOutputLength`) so a header that understates its own size still can't exhaust memory. (issue #167)
- **The extension now declares limited support for untrusted and virtual workspaces.** Previously the undeclared capability meant VS Code disabled the extension entirely in Restricted Mode; only the `sysml.standardLibraryPath` setting — a workspace-settable filesystem path — is now trust-restricted, while highlighting, parsing, diagrams, and library hover work normally on untrusted content. (issue #168)

## [0.9.31] - 2026-07-07

### Changed

- **Diagram previews rebuild far less.** The language server now caches the computed diagram model per parse and view kind, and live-typing re-renders only fetch the current view's model instead of re-detecting all eight view kinds — a live re-render costs 2 model builds instead of up to 18 on large models. (issue #179)

### Fixed

- **Grid View cells are editable in docked mode.** Double-clicking a requirement cell in the docked (side) diagram no longer closes the editor instantly: a plain click now reveals the source without stealing keyboard focus from the diagram in both modes, so the inline cell editor keeps focus; ctrl/⌘+click still jumps into the text editor. (issue #185)

## [0.9.30] - 2026-07-06

### Fixed

- **Diagram toolbar mode button stays visible.** The Dock/Open-as-tab action is now fixed at the far right of the toolbar instead of scrolling with the other controls, and tab mode shows it as an icon-only button.
- **Reset layout sits with the canvas controls.** The "Reset moved nodes to automatic layout" action moved from the crowded top toolbar to the bottom-left canvas control bar, directly beside Fit to view, on every canvas diagram. (issue #168)
- **Grid View row selection stays readable.** Selected requirement rows now use a soft theme-mixed selection color instead of the full active-list selection fill, so colored requirement/link text remains legible in light and dark themes. (issue #168)

## [0.9.29] - 2026-07-06

### Added

- **Geometry View is back — on the interactive canvas.** GEV returned to the view selector, rebuilt on the same React Flow canvas as the other views: parts typed by Geometry-library shapes (Box/Sphere/Cylinder/Cone/Wedge/Pyramid) draw as isometric solids placed by their `x`/`y`/`z` attributes, flat x/y layouts draw as a 2D top-view plan, and the coordinate axes always render — an empty Geometry View is a labelled frame to place parts on, and shape-typed parts without positions stack in a strip below it. Pan/zoom/fit, minimap, click-to-reveal, Properties, and SVG export work like every other view. Positions come from the model's attributes, so geometry objects are deliberately not movable by drag; package overviews stack each part's spatial frame as its own tile.

## [0.9.28] - 2026-07-05

### Changed

- **Connector highlights contrast harder.** Selected connectors and the child-connection highlights use a brighter highlight colour derived from your theme's foreground, so they step away from both the other lines and the canvas on any theme. (issue #164)

- **One toolbar in both modes.** The docked side panel now shows the same single-row toolbar as the full tab — including the General View quick-filter chips (previously a second row) and all editing tools — and the "Diagram" header text is gone. Only the last button differs: it opens the full tab instead of docking. (issue #165)

### Fixed

- **Interconnection View — clicking a port selects the port.** Previously the owning part stayed selected and the code highlight jumped to the part; now the port itself is selected like any other element: its square highlights, Properties shows the port, and its declaration is highlighted in the source. (issue #163)

## [0.9.27] - 2026-07-05

### Added

- **Editing tools live directly on the toolbar.** The ＋Tools toggle and its floating menu are gone — every view shows the add/link tools inside the same top toolbar row in both tab and side mode. If the pane is too narrow, the toolbar uses a custom transparent overlay thumb that appears on hover without changing toolbar height or icon alignment. The strip now offers the **full element vocabulary** a view can depict: the General View gets package + every definition kind (interfaces, connections, calcs, views, viewpoints, renderings, enums, allocations, metadata, occurrences, …). Elements that only make sense inside another element (like an actor in a use case) stay in the right-click menu. (issue #143)

- **General View: a quick-filter chip for parts.** Parts can now be hidden like every other category (the "parts always show" rule is gone). (issue #158)

- **Selecting an element highlights its child connections.** Click a part (or action, or lifeline) and every connection to its immediate children lights up; highlighted connectors also contrast much better with the background on any theme (background halo + accent glow + thicker stroke). (issue #160)

### Changed

- **General View — Full mode is more compact.** Rings sit closer together, boxes closer along each ring, and unrelated clusters pack tighter — with a corrected no-overlap guarantee at every density. (issue #159)

- **Big diagrams are much snappier to drag and pan.** Dragging one element no longer re-renders every connector on the canvas each frame, and very large graphs (300+ elements) only render what is visible in the viewport while panning. (issue #161)

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
