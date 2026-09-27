# Aliot pages and media

The page keeps the preferred draft layout and editorial wireframe sample icons. The hero and view gallery use actual extension SVG exports. The editing section and README lead images now use real VS Code captures. The GIFs join captured states; they are not continuous recordings.

## Real VS Code captures

The `v045-` assets were captured from the running Extension Development Host on 2026-09-27. They use Aliot Light and Aliot Dark. No UI or diagram shapes were redrawn. Crops exclude unrelated editor tabs and the surrounding desktop. See `assets/product/CAPTURES.md` for provenance.

| Files in `assets/product/`                             | Content                                                        |
| ------------------------------------------------------ | -------------------------------------------------------------- |
| `v045-workspace-{light,dark}.png`                      | Browser, drone Interconnection View and Properties together    |
| `v045-properties-{before,edit,after}-{light,dark}.png` | Inherited capacity 80, pending value 95, then a local override |
| `v045-properties-port-{light,dark}.png`                | Port conjugation, calculated direction and directed members    |
| `v045-hierarchy-{overview,subsystem}-{light,dark}.png` | Drone overview and the propulsion diagram opened from Browser  |
| `v045-properties-{light,dark}.gif`                     | Eight-second sequence of the three Properties states           |
| `v045-hierarchy-{light,dark}.gif`                      | Seven-second comparison of the two hierarchy levels            |

The capture model is `reference/fabricated/aliot-release-demo.sysml`. It starts at capacity 80 and validates without diagnostics. Downloadable before and after snapshots are in `assets/samples/release-demo-{before,after}.sysml`. The after state contains the local redefinition produced by Properties. Its Battery definition and spareBattery still use 80.

To reproduce the view, copy `assets/samples/release-demo-layout.json` to the workspace's `.vscode/sysml/diagrams/<relative-model-path>.json`. For the repository's reference workspace, this is `.vscode/sysml/diagrams/fabricated/aliot-release-demo.sysml.json`. Use IV with top-down layout and orthogonal connectors. The overview has propulsion internals collapsed. Its own diagram shows all four motors. Toggle the grid off, fit the diagram, then zoom out if an outside port label needs more padding.

In Browser, select battery and expand Inherited. Change capacity from 80 to 95 and apply with the check mark or Enter. Inspect powerOutput with its row arrow. In Browser, use the propulsion Diagram pill to drill down. Up beside the filter returns to the parent's General View. Choose IV to restore the interconnection overview.

Rebuild the small GIFs from the saved stills:

```powershell
node media/aliot-site/assemble-capture-gifs.mjs
```

The CLI export generator does not touch these versioned capture files. It remains the source of the SVG hero and gallery.

## Generate product media

Models live in `reference/fabricated/aliot-workflow-demo.sysml` and `aliot-landing-views.sysml`. The generator copies their source states to `media/aliot-site/assets/samples/` and exports with the built CLI. The CLI shares the extension's node components and SVG serializer. Generated SVGs are not restyled or hand-edited.

| Output in `assets/product/`          | View and source                                            | Lines      |
| ------------------------------------ | ---------------------------------------------------------- | ---------- |
| `structure-{light,dark}.svg`         | General View on `DeliveryDrone`                            | Curved     |
| `structure-renamed-{light,dark}.svg` | Same model after renaming `controller` to `flightComputer` | Curved     |
| `interconnection-{light,dark}.svg`   | IV on `LandingViews::drone`                                | Orthogonal |
| `behavior-{light,dark}.svg`          | AFV on `LandingViews::Mission`                             | Orthogonal |

`assets/product/EXPORTS.json` records the extension version, source, anchor, view, line style, theme and SVG checksum. Project settings are saved under `assets/samples/{curved,orthogonal}/.vscode/sysml/project.json` so the exports can be reproduced. The orthogonal examples use the extension's left-to-right layout and hide port labels for a compact overview. The saved view settings are beside the sample under `.vscode/sysml/diagrams/`.

```powershell
pnpm build
node media/aliot-site/generate-product-media.mjs --serve
```

Open `http://127.0.0.1:8767/_render` in Chromium. Click **Generate PNGs and GIFs** and wait for **Done**. Stop the server with Ctrl+C. This overwrites generated product media. Without `--serve`, the command regenerates only SVGs and provenance.

Chromium rasterizes the unchanged SVGs so CSS variables, fonts and shadows work as they do in the VS Code webview. The page composes the source panels around these renders. Sharp joins the before/after PNGs into a five-second GIF loop. No diagram shapes are redrawn. Regenerate both stages whenever a model or the renderer changes.

To reproduce a single export:

```powershell
node packages/cli/out/main.js export --file media/aliot-site/assets/samples/workflow-before.sysml --view gv --anchor DeliveryDrone --gv-mode tree --theme light --workspace media/aliot-site/assets/samples/curved --auto-layout --out .temp/structure.svg
```

Both themes are exported independently. The website switches its hero, mini-preview, gallery and capture assets with the theme. Grid exports CSV, not SVG, so the Requirements tab uses an existing public Grid View screenshot. It retains its original theme instead of being recolored.

The hero compares precomputed before/after exports and offers each source for download. It runs no parser. SVG export omits editor-only controls. A real screenshot is needed to match the surrounding VS Code UI exactly.

## Interactive website previews

The hero and gallery support zoom, drag to pan, and Fit. The hero's bottom toolbar also holds Before rename and After rename. The source pane grows to show the full sample without an internal scrollbar. Zoom is relative to the fitted image and ranges from 100% to 400%. Focus the diagram to use + or - for zoom, arrow keys for pan, and 0 or Home for Fit. Normal page scrolling is preserved. Touch dragging pans after zooming in.

Each image fits its frame on load, theme or model-state changes, tab changes and viewport resizing. Without JavaScript, images still fit. The SVG files stay unchanged.

These controls run entirely in browser JavaScript and work on GitHub Pages. Arbitrary model renaming would require a browser modeling runtime and an editing bridge. The current Before rename and After rename buttons compare two actual exports. They are not a live editor. GitHub and Marketplace READMEs retain static images and GIFs; link readers to the website for these controls.

## Replace images and recordings later

Keep replacements in `media/aliot-site/assets/product/` before syncing. Replace the matching `v045-` PNG or GIF from the table above to retain existing links. For a future release, use a new version prefix and update the paths in `index.html`, `script.js`, both README sources and `assemble-capture-gifs.mjs`. New filenames avoid stale Marketplace image caches.

Use Aliot Light and Aliot Dark. Hide unrelated panels, private paths and notifications. Keep the complete diagram and all relevant fields inside the frame. The current wide stills are 1810 by 865 pixels; Properties crops are 530 by 823. Do not stretch a portrait crop into a wide frame.

For a continuous recording, capture a 12 to 18 second sequence: select battery, expand Inherited, enter 95, apply, pause on the local override, open propulsion from Browser, then use Up. A second useful clip can inspect a port and change a directed feature. Keep the recording unhurried and capture each theme separately. Export a GIF for Marketplace and GitHub README use. An MP4 can be added to the website with a poster and playback controls. The current capture tooling produced GIF sequences, so no continuous movie is included yet.

When replacing the Properties GIF with a recording, keep `v045-properties-{light,dark}.gif`, replace its poster `v045-properties-after-{light,dark}.png`, and update the captions and alt text in `index.html`, `script.js` and the README sources. Update `CAPTURES.md` with version, model revision, view, theme and date. The Play button loads the GIF only on request. Stop, closing the panel, or hiding the page stops playback.

The hierarchy buttons compare still captures. Its GIF links provide the two-state sequence. Replacing these PNGs does not change the SVG hero or gallery.

## Sync and publish

### Rebuild the all-view tour

The source is `reference/fabricated/aliot-all-views.sysml`. It covers GV structure and tree, IV, AFV, STV, SV, CV, GEV and the requirements grid. The gallery uses the actual CLI SVG files. Its requirements table is generated from the actual CSV export.

```powershell
pnpm build
node media/aliot-site/generate-all-views.mjs
node media/aliot-site/assemble-all-views-tour.mjs
```

The generator stages its workspace under `.temp/aliot-view-export/`. Public model and configuration downloads go under `assets/samples/`. Light and dark SVGs, the requirements CSV and `EXPORTS.json` go under `assets/product/all-views/`. The manifest records expected visible labels and file hashes. Tooltip titles do not count as visible labels. Missing labels stop assembly of the published tour.

The 0.45.0 audit found and fixed three shared renderer issues: actor name/type captions used the wrong width measurement, sequence loop conditions could overlap activation bars or message captions, and IV spacing did not reserve enough room for ordinary port and connection pills. All expected labels in this showcase now pass the visible-text audit in both themes. This checks the showcase, not every possible model. Long closed compartment rows can still abbreviate by design. Inspect the SVGs visually after regeneration because text presence alone cannot detect overlap.

Edit the descriptions in `assemble-all-views-tour.mjs`. It owns the marked gallery and user-guide tour blocks. Keep both generators together when refreshing the model. Sequence condition placement and full actor captions must remain readable, in addition to passing the text audit. Grid View is CSV, and Browser is a navigation panel with no standalone CLI export.

### Copy to the release repository

```powershell
node scripts/sync-release-page.mjs E:/GitHub/sysml-v2-vscext-release
```

This copies the website, release README, this media guide and assets locally. It also regenerates `user-guide.html` and `user-guide.md` from `docs/user-guide.md`, with matching light and dark captures. Edit the Markdown source, not the generated release guide. Its page shell lives in `media/aliot-site/user-guide.template.html`.

The sync does not push or publish. Existing historical screenshots, changelog and release artifacts are preserved. Review and push the release repository before publishing an extension README that uses new public image URLs.

The Marketplace reads `packages/extension/README.md`. It uses PNG and GIF HTTPS URLs under `https://raw.githubusercontent.com/voidaliot/sysml-v2-vscext-release/main/assets/product/`. Local edits do not make those URLs available. Use versioned filenames or commit-pinned URLs when replacing cached media. SVG masters are used on the website. See [Microsoft publishing guidance](https://code.visualstudio.com/api/working-with-extensions/publishing-extension).

## Design and branding

Maintain `media/aliot-site/`. The draft reference is `media/aliot-landing/`; do not overwrite production files with that raw draft. Keep the flashlight, drone and vehicle SVG drawings in `.sample-visual` and the shared line-icon sprite. Those are editorial icons, not product screenshots. Install buttons use **Install in VS Code**.

The selected store icon is `resources/aliot-light.png`, with a light `#F5F7FB` gallery banner. Brand masters live in `assets/brand/`. The quiet footer expands Aliot as Architecture, Language, Integration, Orchestration, Traceability.

Aliot Light and Aliot Dark retain settings IDs `SysML v2 Gray` and `SysML v2 Default`. The old placeholder generator is retired for product media and refuses to overwrite real exports.

## Preview

```powershell
.venv/Scripts/python.exe -m http.server 8765 --bind 127.0.0.1 --directory E:/GitHub/sysml-v2-vscext-release
```

Open `http://127.0.0.1:8765/`. Check both themes, before/after source matching, SVG loading, view tabs, mobile navigation and playback. Stop the server with Ctrl+C when finished.
