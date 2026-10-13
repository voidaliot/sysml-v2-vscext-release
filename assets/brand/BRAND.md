# Aliot star identity

Updated 13 October 2026 to the approved default icon: a blue-white star with connected blocks, four rays and a black space border. Light/dark aliases intentionally use the same colors. The shared SVG masters live in the aliot.dev repository under `brand/icons/`. Its `npm run brand:sync -- --all --repos-root E:/GitHub` command generates matching local copies for all three sites and both SysML repositories.

The legacy `aliot-marketplace-system-light` and `aliot-marketplace-system-dark` filenames now contain the same compact connected-block star. Their PNGs are 512×512. The private extension uses this exact PNG as `packages/extension/resources/aliot-marketplace.png`. Existing published VSIX files retain their original artwork until a new extension release is built and published.

`aliot-social.png` is the website's 1200×630 sharing image. The live SysML site maintains its realistic rotating hero texture separately, with a black rim applied through CSS. The `old/` directory is archived branding, not the current website identity.

The full icon family is also available under `assets/brand/`: SysML has connected blocks, CLI an amber `>_` prompt, Codbase violet `</>` code brackets, and SwaML teal architecture layers. All resources are served locally.
