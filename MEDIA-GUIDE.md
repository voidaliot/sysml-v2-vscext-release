# Aliot pages and media

The release page and README currently use clearly labeled illustrative media. They are not screenshots of the released extension. Replace them with real captures before presenting them as product evidence.

## Files and ownership

The development repository owns the page source under `media/aliot-site/`. The public release repository receives `index.html`, `styles.css`, `script.js`, `README.md`, `MEDIA-GUIDE.md` and the owned asset folders. Existing user guides, changelog, old screenshots and release artifacts are preserved.

| Source in development repository | Public release repository |
| --- | --- |
| `media/aliot-site/index.html`, `styles.css`, `script.js` | Same names at root |
| `media/aliot-site/release-README.md` | `README.md` |
| `media/aliot-site/assets/brand/` | `assets/brand/` |
| `media/aliot-site/assets/product/` | `assets/product/` |
| `media/aliot-site/assets/samples/` | `assets/samples/` |
| `docs/release-media-guide.md` | `MEDIA-GUIDE.md` |

From the development repository, copy the reviewed files to the release checkout:

```powershell
node scripts/sync-release-page.mjs E:/GitHub/sysml-v2-vscext-release
```

This copies files locally. It does not commit, push, publish an extension or deploy a site. It overwrites the owned destination files, so keep replacement media in the development source as well. Review the release-repository diff before committing.

## Replace the images and GIFs

Replace the following files in `media/aliot-site/assets/product/` without changing their names. Each comes in `-light` and `-dark` versions. The website selects them with its theme toggle; the READMEs use the light versions.

| Filename stem | Capture to provide |
| --- | --- |
| `workspace` (`.png`) | Source on the left and a readable General View on the right, with 6 to 8 visible elements |
| `structure` (`.png`) | A focused General View showing definitions or nested parts |
| `interconnection` (`.png`) | Ports and connections, with Properties open and no context menu hiding the model |
| `editing-poster` (`.png`) | The first useful frame of the editing recording |
| `editing` (`.gif`) | Rename in the diagram, observe the source update, then edit a value in the source and observe the diagram |

For example: `workspace-light.png`, `workspace-dark.png`, `editing-light.gif`, `editing-dark.gif`. An interim release may use the same real capture in both theme files if only one theme has been recorded. Keep the capture's actual appearance; do not label a light screenshot as a dark-theme demonstration.

Recommended capture sequence:

1. Open the same validated public model for every capture. Start with `reference/fabricated/aliot-first-model.sysml` and use the drone sample for ports.
2. Use **Aliot Dark** for dark captures and **SysML v2 Gray** for light captures. Hide unrelated panels, private file paths and notifications. Make code and labels readable at the final display size.
3. Record 12 to 18 seconds: hold the initial view, rename a part through Properties, pause on the changed source, then edit a source value and pause on the changed diagram. Avoid fast pointer motion.
4. Export PNG stills, preferably 1200 by 680 pixels or a similar aspect ratio. Export GIFs around 1000 to 1200 pixels wide and 10 to 12 frames per second. Aim below 5 MB per GIF. These are practical targets, not store limits.
5. Replace the placeholder files. In `index.html`, update each affected `alt` and `figcaption`. In `script.js`, update the two workflow caption strings. Remove placeholder wording only for media that has actually been replaced. Update the captions in both READMEs too.
6. Record extension version, model revision, theme, view and capture date in a small `assets/product/CAPTURES.md` file. These fields help keep claims aligned with the release.
7. Run the sync command above. Commit and push the release repository when ready to publish the site and make the image URLs public. Then package and publish the extension through the normal release flow.

The website starts on a static poster. Play explicitly loads the GIF. Stop restores the poster, and switching away from the page stops playback. The GIF in a Markdown README animates as a normal image. Link longer videos from a static thumbnail to the website instead of depending on embedded video or JavaScript in Marketplace Markdown.

## Marketplace wiring

`packages/extension/package.json` owns the title, description, icon and gallery banner. The selected store icon is `resources/aliot-light.png`. The pale banner is `#F5F7FB`, with light-theme text treatment. The icon also appears on search cards; the gallery banner and README media appear on the detail page.

`packages/extension/README.md` uses explicit public HTTPS image URLs, for example:

```markdown
![Source beside a diagram](https://raw.githubusercontent.com/voidaliot/sysml-v2-vscext-release/main/assets/product/workspace-light.png)
![Diagram editing demonstration](https://raw.githubusercontent.com/voidaliot/sysml-v2-vscext-release/main/assets/product/editing-light.gif)
```

Publish those files to the public repository before publishing the updated extension README. Local edits alone do not make the HTTPS URLs available. To avoid stale caches after future replacements, use new versioned filenames and update the links, or pin the URL to a reviewed public commit.

The Marketplace reads the packaged extension README, not the root development README. Changing its text requires publishing an updated extension package. The website is the public repository's GitHub Pages site; verify Pages still serves the configured root after pushing.

Use PNG or GIF in the Marketplace README. Keep SVG masters for the website and brand editing. [Microsoft publishing guidance](https://code.visualstudio.com/api/working-with-extensions/publishing-extension) covers HTTPS image links and SVG restrictions.

## Brand and theme

`assets/brand/aliot-light.svg` and `aliot-dark.svg` are the editable icon masters. PNGs are 512 by 512 pixels. `aliot.png` and `aliot.svg` are the selected light mark. The 1200 by 630 `aliot-social.png` is the social preview.

The name expansion belongs in the footer: Architecture, Language, Integration, Orchestration, Traceability. It should support the product name rather than replace the product introduction.

**Aliot Dark** is the new visible name of the former **SysML v2 Default** theme. Its contributed ID remains `SysML v2 Default` for settings compatibility. The theme palette and `SysML v2 Gray` remain unchanged.

The placeholder generator is an authoring tool:

```powershell
node media/aliot-site/generate-placeholders.mjs
```

It refuses to overwrite existing output. `--replace` regenerates all placeholder media and icon PNGs. Do not use it after adding real captures unless intentionally restoring the placeholders.

## Preview and check

Serve the release repository with a local static server and open its root. Check light/dark toggle persistence, the play/stop button, image loading, keyboard focus and mobile wrapping. Without JavaScript, the light page and static posters remain readable.

For example, from the development repository:

```powershell
.venv/Scripts/python.exe -m http.server 8765 --bind 127.0.0.1 --directory E:/GitHub/sysml-v2-vscext-release
```

Then open `http://127.0.0.1:8765/`. Stop the server with Ctrl+C when finished.
