# SysML v2 for Visual Studio Code

<p align="center">
  <img src="packages/extension/resources/icon.png" alt="SysML v2 extension icon" width="120" height="120"/>
</p>

<p align="center">
  <strong>A complete SysML v2 and KerML modeling environment for VS Code, with language intelligence, the official standard library, and live editable diagrams.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/SysML%20v2-KerML-6d28d9" alt="SysML v2 / KerML"/>
  <img src="https://img.shields.io/badge/VS%20Code-%5E1.90-007ACC?logo=visualstudiocode&logoColor=white" alt="VS Code ^1.90"/>
  <img src="https://img.shields.io/badge/no%20Java-no%20PlantUML-success" alt="No Java, no PlantUML"/>
  <img src="https://img.shields.io/badge/license-Apache--2.0-blue" alt="Apache-2.0"/>
</p>

This repository contains a VS Code extension for writing, navigating, validating, and visualizing **SysML v2** and **KerML** models. It is built on [Langium](https://langium.org), runs locally, bundles the official OMG SysML v2 standard library, and renders SysML v2 graphical views directly in VS Code without Java, PlantUML, or a diagram server.

The root project is a pnpm monorepo:

- `packages/language` - Langium grammar and generated AST
- `packages/language-server` - LSP server and SysML services
- `packages/extension` - VS Code extension client, TextMate grammars, snippets, theme, webviews, and packaged resources

## Feature Highlights

- **SysML v2 and KerML language support** for `.sysml` and `.kerml` files, including TextMate highlighting, parser-backed diagnostics, semantic tokens, snippets, and formatting.
- **Broad grammar coverage** across structural, behavioral, requirements, cases, views, metadata, KerML kernel constructs, expressions, relationships, qualifiers, actions, control flow, and quantity literals.
- **Full editor intelligence**: completion, inline completion, hover, signature help, document symbols, workspace symbols, folding, document highlights, inlay hints, CodeLens, go-to-definition, go-to-declaration, find references, and cross-file rename.
- **Stable diagnostic catalogue** with LEX, SYN, RES, SEM, SSM, KSM, UNIT, STYL, and MIG families, per-code severity overrides, quick fixes, style checks, dimensional-analysis diagnostics, and SysML v1-to-v2 migration guardrails.
- **Auto-import on save** for unambiguous cross-package names, with a picker when a name has multiple possible packages.
- **Live editable diagrams** in SysML v2 notation, rendered on a React Flow + elk.js canvas instead of PlantUML. The extension supports General, Interconnection, Action Flow, State Transition, Sequence, Case, Geometry, Grid, and Browser views.
- **Diagram editing** through the language server: drag, resize, rename, add members, delete elements, reshape connectors with draggable waypoints, edit the Grid View's requirements table in place, and draw view-specific relationships such as connect, bind, transition, succession, message, include, and satisfy.
- **Bundled OMG standard library** with the Systems Library, Kernel libraries, Quantities and Units libraries, Geometry, Metadata, Analysis, Cause and Effect, and Requirement Derivation packages indexed at startup.
- **Archive and interchange workflows** for `.kpar` archives and OMG abstract-syntax JSON import/export.
- **AI-agent tool surface** for VS Code language-model tools: modeling guidance, context gathering, draft validation, library/unit search, symbol resolution, requirement tracing, and diagnostic explanation.
- **Privacy-first behavior**: no telemetry, no analytics SDK, and no network calls beyond the local language server.

For the exact current feature matrix, see [docs/features-overview.md](docs/features-overview.md). For requirement-level traceability, see [docs/requirements.md](docs/requirements.md).

## Quick Start

1. Install the extension from a packaged `.vsix` or build it from source.
2. Open or create a `.sysml` or `.kerml` file.
3. Wait for the status bar to report `SysML: ready`.
4. Type `sysml-` to insert one of the bundled scaffolding snippets, such as `sysml-part-def`, `sysml-requirement`, or `sysml-state-machine`.
5. Save the file to run diagnostics and auto-import planning.
6. Run **SysML: Show Diagram** from the Command Palette or the editor title graph button to open a live diagram. Use **SysML: Toggle Diagram Side / Tab Mode** or `Ctrl+Alt+D` to switch between compact side view and full tab view.

Try [examples/flashlight.sysml](examples/flashlight.sysml) or another model under [examples](examples) to explore the language services.

## Installation

### Install a packaged extension

1. Download a `.vsix` from the [project releases](https://github.com/voidaliot/sysml-v2-vsc-ext/releases).
2. In VS Code, open **Extensions**.
3. Choose **... -> Install from VSIX...**.
4. Select the downloaded package.

### Build from source

Prerequisites:

- Node.js 20+
- pnpm 9+
- VS Code 1.90+

```bash
git clone https://github.com/voidaliot/sysml-v2-vsc-ext.git
cd sysml-v2-vsc-ext
pnpm install
pnpm build
pnpm --filter=vscode-sysml-v2 package
```

The package command creates a `.vsix` in `packages/extension/`.

## Language Intelligence

The extension treats SysML as a real programming language inside VS Code:

- Syntax highlighting for keywords, declarations, comments, doc comments, strings, escaped names, operators, quantity literals such as `1500 [kg]`, and invalid legacy/operator forms.
- Completion for keywords, snippets, imports, members, units, metadata annotations, requirement targets, connection endpoints, and library functions.
- Inline ghost-text suggestions for common valid skeletons, including empty definitions, missing requirement subjects, package imports, and transition targets.
- Hover cards for element kind, name, typing, multiplicity, doc comments, relationship details, library symbols, quantity units, keyword help, and operator help.
- Parser-backed diagnostics and semantic checks with mechanical quick fixes for common edits.
- Navigation across files and into the bundled read-only standard library.
- AST-based formatting using VS Code's `editor.tabSize` and `editor.insertSpaces`.
- Requirement reference counts and runnable verification-case CodeLens entries.

## Diagrams

The diagram preview is a live view of the textual model. It is rendered inside VS Code on a theme-aware React Flow + elk.js canvas, not PlantUML. Connectors draw beneath the parts and are smart-routed around them; in the Interconnection View each part is a resizable frame whose ports are large click-to-connect targets.

| View | Shows |
|------|-------|
| General | Definitions and usages, packages, imports, dependency/satisfy/verify/derive/allocate links, composition and full specialization-family arrows (subsets/redefines/references), constraints, views, variation/variant notation, metadata badges, annotations |
| Interconnection | Parts, ports, interfaces, bindings, item flows |
| Action Flow | Actions, control nodes, send/accept nodes, item flows, performer swimlanes |
| State Transition | States, composite and parallel states, transitions, guards, effects, final states |
| Sequence | Lifelines, activations, messages, replies, event occurrences, `occurrence def`/`occurrence` interactions |
| Case | Use, analysis, and verification cases with subjects, actors, includes, and specialization |
| Geometry | Parts placed on an x/z frame |
| Grid | Requirements table, editable in place, with one column per attribute, separate Constraint/Satisfy/Verify columns, and status |
| Browser | Package and membership tree |

Diagrams support side-panel and full-tab modes. Layout state is stored in repo-local side-car files under `.vscode/sysml/diagrams/`, so positions and sizes can be versioned without changing the `.sysml` source. Project-level diagram settings can be checked in under `.vscode/sysml/project.json`.

## Standard Library

The extension vendors the official [OMG SysML v2 Release](https://github.com/Systems-Modeling/SysML-v2-Release) standard library under `packages/extension/resources/sysml.library/`.

| Layer | Examples |
|-------|----------|
| Systems Library | `Parts`, `Ports`, `Items`, `Attributes`, `Actions`, `States`, `Requirements`, `Constraints`, `Calculations`, `Cases`, `Views`, `SysML` |
| Kernel Libraries | Kernel Data Type Library, Kernel Function Library, Kernel Semantic Library |
| Quantities and Units | `ISQBase`, `ISQMechanics`, `ISQElectromagnetism`, `SI`, `SIPrefixes`, `USCustomaryUnits`, `Quantities`, `Time` |
| Other domain libraries | Analysis, Cause and Effect, Geometry, Metadata, Requirement Derivation |

Symbols from the bundled library are available through a precomputed index, so normal startup does not parse the full library. `sysml.standardLibraryPath` can point to an external `sysml.library/` tree, a `.kpar` archive, or a directory of `.kpar` archives.

## Commands

Common command palette entries:

- **SysML: Show Diagram**
- **SysML: Which Diagram? (view guidance)**
- **SysML: Toggle Diagram Side / Tab Mode**
- **SysML: Restart Language Server**
- **SysML: Reload Standard Library**
- **SysML: Open Standard Library Folder**
- **SysML: Open .kpar Archive**
- **SysML: Extract .kpar Archive**
- **SysML: Open Abstract Syntax JSON**
- **SysML: Export Abstract Syntax JSON**
- **SysML: Show Syntax Tree**
- **SysML: Show Diagnostic Reference**
- **SysML: Report Parse Coverage**

## Settings

Open **Settings -> Extensions -> SysML v2** in VS Code. Important settings include:

| Setting | Default | Purpose |
|---------|---------|---------|
| `sysml.standardLibraryPath` | bundled library | Use an external standard library tree, `.kpar`, or `.kpar` directory |
| `sysml.validation.severities` | `{}` | Override individual diagnostic code severities |
| `sysml.diagnostics.unusedImports` | `off` | Report unused imports as warning or error |
| `sysml.diagnostics.units` | `true` | Enable quantity and dimensional-analysis diagnostics |
| `sysml.editor.autoImportOnSave` | `true` | Add missing imports for unambiguous cross-package names on save |
| `sysml.inlineCompletion.enabled` | `true` | Enable SysML ghost-text suggestions |
| `sysml.inlayHints.dimension` | `false` | Show opt-in physical-dimension hints |
| `sysml.workspace.backgroundIndexing` | `imports` | Control low-priority workspace indexing |
| `sysml.preview.diagrams.update` | `on-save` | Control diagram refresh behavior |
| `sysml.preview.diagrams.defaultKind` | `gv` | Preferred initial diagram view |
| `sysml.preview.diagrams.defaultMode` | `side` | Open diagrams in side or tab mode |
| `sysml.preview.diagrams.showSubjectAsBoundaryBox` | `true` | Case View: draw the subject as a v1-style system boundary box |
| `sysml.preview.diagrams.syncUsageToDef` | `true` | Interconnection View edits synchronize to the typed definition |
| `sysml.trace.server` | `off` | Enable LSP message tracing for debugging |

The marketplace-facing README in [packages/extension/README.md](packages/extension/README.md) contains the full settings and diagnostic-code reference.

## Development

Install dependencies and build all packages:

```bash
pnpm install
pnpm build
```

Run the extension in a VS Code Extension Development Host by opening this repository in VS Code and pressing `F5`. The launch task builds the extension before starting the dev host.

Useful commands:

```bash
pnpm --filter=sysml-language build          # regenerate/check the grammar package
pnpm --filter=sysml-language-server build   # build the language server
pnpm --filter=vscode-sysml-v2 build         # build the VS Code extension bundle
pnpm lint                                   # lint packages
pnpm test                                   # run the full test suite
pnpm corpus:audit                           # optional parser coverage audit
```

CI runs `pnpm lint`, `pnpm build`, and `pnpm test`. The full test suite includes TextMate scope tests, parser and corpus tests, and language-server integration tests.

## Documentation

- [Feature overview](docs/features-overview.md) - public summary of what works today
- [Requirements](docs/requirements.md) - canonical requirement list with implementation status
- [Requirement implementation map](docs/req-implementation-map.md) - reverse index from files to REQ IDs
- [Architecture](docs/architecture.md) - design and service architecture
- [User acceptance guideline](docs/user-acceptance-guideline.md) - human acceptance checklist
- [Publishing guide](docs/publishing-guide.md) - packaging and publishing process
- [Project status](STATUS.md) - dated dev-progress log, newest first
- [Changelog](packages/extension/CHANGELOG.md) - official, release-facing change history
- [Tasks](docs/tasks.md) - process/infra task tracking
- [Issues](issues.md) - user-reported issues and their resolutions

## Contributing

Issues and pull requests are welcome. Before changing grammar, language-server behavior, settings, or public claims, read:

- [docs/features-overview.md](docs/features-overview.md)
- [docs/requirements.md](docs/requirements.md)
- [docs/architecture.md](docs/architecture.md)
- [AGENTS.md](AGENTS.md)

Implementation requirements are traced with inline `// REQ-NNN` comments in code and matching `Architecture` fields in [docs/requirements.md](docs/requirements.md). Please keep code, tests, docs, and public README claims in sync.

## License and Attribution

The extension code is licensed under [Apache-2.0](LICENSE).

The bundled `sysml.library/` files are taken from the official OMG SysML v2 Release and carry their upstream LICENSE / LICENSE-GPL terms. See [packages/extension/resources/sysml.library/NOTICE.md](packages/extension/resources/sysml.library/NOTICE.md).

Built with [Langium](https://langium.org), [vscode-languageclient](https://github.com/microsoft/vscode-languageserver-node), [Preact](https://preactjs.com), and a [React Flow](https://reactflow.dev) + [elk.js](https://github.com/kieler/elkjs) diagram canvas.
