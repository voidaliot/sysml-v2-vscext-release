/* Aliot website. Diagram previews use actual precomputed extension SVG exports. */
(() => {
  "use strict";
  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];
  // Both images are unmodified CLI exports of the downloadable source states.
  function setExportStep(step) {
    const after = step === "1";
    const stem = after ? "structure-renamed" : "structure";
    const diagram = $("#hero-diagram");
    diagram.dataset.light = `assets/product/${stem}-light.svg`;
    diagram.dataset.dark = `assets/product/${stem}-dark.svg`;
    diagram.src = diagram.dataset[document.documentElement.dataset.theme];
    $("#source-before").hidden = after;
    $("#source-after").hidden = !after;
    $("#selection-label").textContent = after ? "After: flightComputer" : "Before: controller";
    $("#source-download").href = `assets/samples/workflow-${after ? "after" : "before"}.sysml`;
    $$("[data-export-step]").forEach((button) =>
      button.setAttribute("aria-pressed", String(button.dataset.exportStep === step)),
    );
  }
  $$("[data-export-step]").forEach((button) =>
    button.addEventListener("click", () => setExportStep(button.dataset.exportStep)),
  );

  // Keyboard-accessible tablist. All panel content is present in the HTML.
  const tabs = $$(".view-tab");
  function activateTab(tab, focus = false) {
    for (const item of tabs) {
      const active = item === tab;
      item.setAttribute("aria-selected", String(active));
      item.tabIndex = active ? 0 : -1;
      document.getElementById(item.getAttribute("aria-controls")).hidden = !active;
    }
    if (focus) tab.focus();
  }
  tabs.forEach((tab, index) => {
    tab.addEventListener("click", () => activateTab(tab));
    tab.addEventListener("keydown", (event) => {
      let next;
      if (event.key === "ArrowRight") next = (index + 1) % tabs.length;
      if (event.key === "ArrowLeft") next = (index - 1 + tabs.length) % tabs.length;
      if (event.key === "Home") next = 0;
      if (event.key === "End") next = tabs.length - 1;
      if (next !== undefined) {
        event.preventDefault();
        activateTab(tabs[next], true);
      }
    });
  });

  const root = document.documentElement;
  const toggle = document.getElementById("theme-toggle");
  const demo = document.getElementById("workflow-image");
  const play = document.getElementById("demo-toggle");
  const caption = document.getElementById("demo-caption");
  const system = matchMedia("(prefers-color-scheme: dark)");
  let preference;
  let playing = false;
  try {
    preference = localStorage.getItem("aliot-theme");
  } catch {
    /* Storage is optional. */
  }
  if (!["light", "dark"].includes(preference)) preference = null;

  function updateDemo() {
    const theme = root.dataset.theme;
    demo.src = playing ? `assets/product/editing-${theme}.gif` : demo.dataset[theme];
    play.textContent = playing ? "Stop sample animation" : "Play sample animation";
    play.setAttribute("aria-pressed", String(playing));
    caption.textContent = playing
      ? "Actual SVG export sequence, not a screen recording. Press Stop to return to the still image."
      : "Actual SVG export sequence, not a screen recording. Animation starts only when you press Play.";
  }

  function applyTheme(theme) {
    root.dataset.theme = theme;
    toggle.setAttribute("aria-label", `Switch to ${theme === "dark" ? "light" : "dark"} theme`);
    document.querySelector('meta[name="theme-color"]').content =
      theme === "dark" ? "#080c13" : "#f7f9fc";
    document.querySelectorAll("img[data-light]").forEach((image) => {
      image.src = image.dataset[theme];
    });
    updateDemo();
  }

  toggle.addEventListener("click", () => {
    preference = root.dataset.theme === "dark" ? "light" : "dark";
    try {
      localStorage.setItem("aliot-theme", preference);
    } catch {
      /* The toggle still works. */
    }
    applyTheme(preference);
  });
  system.addEventListener("change", (event) => {
    if (!preference) applyTheme(event.matches ? "dark" : "light");
  });
  play.addEventListener("click", () => {
    playing = !playing;
    updateDemo();
  });
  document.addEventListener("visibilitychange", () => {
    if (document.hidden && playing) {
      playing = false;
      updateDemo();
    }
  });
  applyTheme(preference || (system.matches ? "dark" : "light"));

  document.querySelector(".recording-panel").addEventListener("toggle", (event) => {
    if (!event.currentTarget.open && playing) {
      playing = false;
      updateDemo();
    }
  });
  if (location.hash === "#editing") document.querySelector(".recording-panel").open = true;

  const menu = $("#main-nav");
  const menuButton = $("#menu-toggle");
  function closeMenu() {
    menu.classList.remove("is-open");
    menuButton.setAttribute("aria-expanded", "false");
    menuButton.setAttribute("aria-label", "Open navigation");
  }
  menuButton.addEventListener("click", () => {
    const open = !menu.classList.contains("is-open");
    menu.classList.toggle("is-open", open);
    menuButton.setAttribute("aria-expanded", String(open));
    menuButton.setAttribute("aria-label", open ? "Close navigation" : "Open navigation");
  });
  $$("#main-nav a").forEach((link) => link.addEventListener("click", closeMenu));
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeMenu();
  });
  document.addEventListener("click", (event) => {
    if (menu.classList.contains("is-open") && !event.target.closest(".site-header")) closeMenu();
  });
  window.addEventListener("resize", () => {
    if (window.innerWidth > 760) closeMenu();
  });

  let toastTimer;
  function toast(text) {
    const element = $("#toast");
    element.textContent = text;
    element.classList.add("show");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => element.classList.remove("show"), 3000);
  }
  const commands =
    "npx sysml-validate models/ --strict\n\nnpx sysml-diagram export \\\n  --file models/drone.sysml \\\n  --view iv --out docs/drone.svg";
  $("#copy-cli").addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(commands);
      toast("Example commands copied.");
    } catch (_) {
      const textarea = document.createElement("textarea");
      textarea.value = commands;
      textarea.style.cssText = "position:fixed;left:-10000px;top:0";
      document.body.append(textarea);
      textarea.select();
      const copied = document.execCommand("copy");
      textarea.remove();
      $("#copy-cli").focus();
      toast(
        copied
          ? "Example commands copied."
          : "Copy is unavailable. Select the displayed commands manually.",
      );
    }
  });

  $$("[data-close-dialog]").forEach((button) =>
    button.addEventListener("click", () => button.closest("dialog").close()),
  );
  $$("dialog").forEach((dialog) =>
    dialog.addEventListener("click", (event) => {
      const box = dialog.getBoundingClientRect();
      if (
        event.target === dialog &&
        (event.clientX < box.left ||
          event.clientX > box.right ||
          event.clientY < box.top ||
          event.clientY > box.bottom)
      )
        dialog.close();
    }),
  );

  // Real repository media is never loaded automatically. The default concept is offline.
  const captureDialog = $("#capture-dialog");
  const captureImage = $("#capture-image");
  const captureMessage = $("#capture-message");
  const allowedCaptures = new Set([
    "feature-editor-diagram-workspace.png",
    "feature-diagram-interconnection.png",
    "feature-diagram-action-flow.png",
    "feature-diagram-grid.png",
  ]);
  let captureTimer;
  function failedCapture() {
    captureImage.hidden = true;
    captureMessage.hidden = false;
    $("#capture-status").textContent = "The online capture could not be loaded.";
    $("#capture-explanation").textContent =
      "Open the original on GitHub below. Your browser may be offline or may restrict external images.";
  }
  $$(".capture-link").forEach((button) =>
    button.addEventListener("click", () => {
      const file = button.dataset.capture;
      if (!allowedCaptures.has(file)) return;
      clearTimeout(captureTimer);
      captureImage.hidden = true;
      captureImage.removeAttribute("src");
      captureMessage.hidden = false;
      $("#capture-status").textContent = "Loading the public product capture…";
      $("#capture-explanation").textContent =
        "This is an existing release-repository image. An internet connection is required.";
      $("#capture-title").textContent = `${button.dataset.caption} : existing product capture`;
      $("#capture-original").href =
        `https://github.com/voidaliot/sysml-v2-vscext-release/blob/main/assets/screenshots/${file}`;
      captureImage.alt = `Existing Aliot ${button.dataset.caption.toLowerCase()} screenshot from the public release repository`;
      captureImage.onload = () => {
        clearTimeout(captureTimer);
        captureMessage.hidden = true;
        captureImage.hidden = false;
      };
      captureImage.onerror = () => {
        clearTimeout(captureTimer);
        failedCapture();
      };
      captureDialog.showModal();
      captureImage.src = `https://raw.githubusercontent.com/voidaliot/sysml-v2-vscext-release/main/assets/screenshots/${file}`;
      captureTimer = setTimeout(failedCapture, 10000);
    }),
  );
  captureDialog.addEventListener("close", () => clearTimeout(captureTimer));
})();
