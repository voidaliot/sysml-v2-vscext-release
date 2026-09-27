(() => {
  const root = document.documentElement;
  const button = document.getElementById("guide-theme");
  const system = matchMedia("(prefers-color-scheme: dark)");
  let preference;
  try {
    preference = localStorage.getItem("aliot-theme");
  } catch {
    /* Optional persistence. */
  }
  function apply(theme) {
    root.dataset.theme = theme;
    button.textContent = theme === "dark" ? "Light theme" : "Dark theme";
    button.setAttribute("aria-label", `Switch to ${theme === "dark" ? "light" : "dark"} theme`);
    document.querySelector('meta[name="theme-color"]').content =
      theme === "dark" ? "#080c13" : "#f7f9fc";
    document.querySelectorAll("img[data-light]").forEach((image) => {
      image.src = image.dataset[theme];
    });
  }
  button.hidden = false;
  button.addEventListener("click", () => {
    preference = root.dataset.theme === "dark" ? "light" : "dark";
    try {
      localStorage.setItem("aliot-theme", preference);
    } catch {
      /* Theme still changes. */
    }
    apply(preference);
  });
  system.addEventListener("change", () => {
    if (!preference) apply(system.matches ? "dark" : "light");
  });
  apply(
    preference === "dark" || preference === "light"
      ? preference
      : system.matches
        ? "dark"
        : "light",
  );
})();
