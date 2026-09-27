# Aliot pages and media

The page keeps the preferred draft layout and editorial wireframe sample icons. Product diagrams use actual extension SVG exports. Website frames and source panels are composed around them. The animation compares exported model states; it is not a screen recording.

## Generate product media

Models live in `reference/fabricated/aliot-workflow-demo.sysml` and `aliot-landing-views.sysml`. The generator copies their source states to `media/aliot-site/assets/samples/` and exports with the built CLI. The CLI shares the extension's node components and SVG serializer. Generated SVGs are not restyled or hand-edited.

| Output in `assets/product/` | View and source | Lines |
| --- | --- | --- |
| `structure-{light,dark}.svg` | General View on `DeliveryDrone` | Curved |
| `structure-renamed-{light,dark}.svg` | Same model after renaming `controller` to `flightComputer` | Curved |
| `interconnection-{light,dark}.svg` | IV on `LandingViews::drone` | Orthogonal |
| `behavior-{light,dark}.svg` | AFV on `LandingViews::Mission` | Orthogonal |

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

Both themes are exported independently. The website switches its hero, mini-preview, gallery and animation assets with the theme. Grid exports CSV, not SVG, so the Requirements tab uses an existing public Grid View screenshot. It retains its original theme instead of being recolored.

The hero compares precomputed before/after exports and offers each source for download. It runs no parser. SVG export omits editor-only controls. A real screenshot is needed to match the surrounding VS Code UI exactly.

## Replace images and recordings later

Keep replacement files in `media/aliot-site/assets/product/` before syncing. Use the existing light/dark filenames:

| Files | Suggested capture |
| --- | --- |
| `workspace-{light,dark}.png` | Source editor beside readable General View |
| `structure-{light,dark}.png` | Focused General View |
| `interconnection-{light,dark}.png` | Ports, connections and Properties |
| `editing-poster-{light,dark}.png` | First useful recording frame |
| `editing-{light,dark}.gif` | Rename through Properties, pause on source update, then change a value |

Use Aliot Light and Aliot Dark. Hide unrelated panels, private paths and notifications. Prefer 1200 by 680 stills and a 12 to 18 second recording. Aim for GIFs below 5 MB. These are practical targets, not store limits.

Update affected alt text, captions, README descriptions and the two playback caption strings in `script.js`. Record the extension version, model revision, view, theme and date in `assets/product/CAPTURES.md`. Do not rerun generation over real captures unless you intend to replace them with export sequences.

Replacing PNGs does not change the SVG gallery. Change its image paths in `index.html` if you want screenshots there. The `#editing` panel loads its GIF only after Play. Stop, closing the panel, or hiding the page stops playback.

## Sync and publish

```powershell
node scripts/sync-release-page.mjs E:/GitHub/sysml-v2-vscext-release
```

This copies the website, release README, this guide and assets locally. It does not push or publish. Existing historical screenshots, guides, changelog and release artifacts are preserved. Review and push the release repository before publishing an extension README that uses new public image URLs.

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
