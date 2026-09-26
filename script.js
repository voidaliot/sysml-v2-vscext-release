(() => {
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
      ? "Illustration placeholder, not a product recording. Press Stop to return to the still image."
      : "Illustration placeholder, not a product recording. Animation starts only when you press Play.";
  }

  function applyTheme(theme) {
    root.dataset.theme = theme;
    toggle.textContent = theme === "dark" ? "Light theme" : "Dark theme";
    toggle.setAttribute("aria-label", `Switch to ${theme === "dark" ? "light" : "dark"} theme`);
    document.querySelector('meta[name="theme-color"]').content =
      theme === "dark" ? "#080c13" : "#f5f7fb";
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
})();
