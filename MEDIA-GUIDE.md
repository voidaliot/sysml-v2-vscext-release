# Replacing Aliot images and animations

The page shows real VS Code captures and SVG diagrams exported by sysml-diagram. Keep the extension and CLI versions aligned when updating it.

## Export diagrams

Install [sysml-diagram from npm](https://www.npmjs.com/package/sysml-diagram):

```sh
npm install -g sysml-diagram
sysml-diagram --version
```

Download [aliot-all-views.sysml](https://github.com/voidaliot/sysml-v2-samples/blob/main/aliot-all-views.sysml). Open it in VS Code and follow the [view-by-view guide](https://voidaliot.github.io/sysml-v2-vscext-release/user-guide.html#all-view-model-tour). Save the layout. Run **SysML: Copy Headless CLI Command** to reproduce that view. For a fresh arrangement:

```sh
sysml-diagram export --file aliot-all-views.sysml --view iv --anchor AliotShowcase::Architecture::drone --theme light --auto-layout --out iv-light.svg
sysml-diagram export --file aliot-all-views.sysml --view iv --anchor AliotShowcase::Architecture::drone --theme dark --auto-layout --out iv-dark.svg
```

Replace the matching files under `assets/product/all-views/`. Keep their names so the theme toggle and guide links continue to work. Review both themes at full size. Check labels, connector paths and image framing. Grid View uses a VS Code screenshot and **Export CSV**.

## Capture editing and navigation

Use the [release demo](https://github.com/voidaliot/sysml-v2-samples/blob/main/release-demo-before.sysml).

1. Choose Aliot Light. Open the drone's Interconnection View, Browser and Properties.
2. Select battery. Capture capacity 80, entering 95, and the applied local override. Show that spareBattery remains 80.
3. Select the powerOutput port and capture its type, conjugation and directed members in Properties.
4. Capture the drone overview. Use the **Diagram** pill beside propulsion in Browser to open the subsystem. Capture its four motors and use **Up** to return.
5. Repeat with Aliot Dark. Crop unrelated windows and workspace information, while retaining enough UI to explain the action.

Replace the corresponding `v045-properties-*`, `v045-hierarchy-*` and `v045-workspace-*` files under `assets/product/`. Keep light and dark stills. The hierarchy GIFs are sequences of real captured states, not continuous recordings.

## Record a short GIF

For Properties, capture the before and after states as separate PNGs in both themes. The landing page lets viewers select each state. For hierarchy navigation, save a GIF using the existing `v045-hierarchy-light.gif` name and provide the matching dark variant. Keep still images for people who prefer reduced motion.

GitHub README and Marketplace pages can display linked PNGs and GIFs. They do not run interactive diagram JavaScript. Use the GitHub Pages site for the zoomable preview and link to it from the README. A simple embed is:

```md
![Battery Properties after applying a local capacity override](https://raw.githubusercontent.com/voidaliot/sysml-v2-vscext-release/main/assets/product/v045-properties-after-light.png)
```

Keep animations small enough to load quickly. Update alt text and captions whenever the demonstrated behavior changes.
