import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panelContainer"];

  connect() {
    this.initializePanels();
    document.addEventListener("turbo:load", this.initializePanels.bind(this));
  }

  initializePanels() {
    const currentPath = window.location.pathname;
    this.panelContainerTargets.forEach((container) => {
      const panel = container.querySelector(".panel");
      const panelUrl = panel.dataset.url;
      const isActive = currentPath.startsWith(panelUrl);
      panel.setAttribute("aria-expanded", isActive);
      // If active, trigger loading content (if not loaded yet)
      if (isActive) {
        this.activatePanel(panel);
      } else {
        this.deactivatePanel(panel);
      }
    });
  }

  toggle(event) {
    event.preventDefault();
    const clickedPanel = event.currentTarget;
    if (clickedPanel.getAttribute("aria-expanded") === "true") return;

    // Deactivate all panels.
    this.panelContainerTargets.forEach((container) => {
      const panel = container.querySelector(".panel");
      this.deactivatePanel(panel);
    });

    // Activate the clicked panel.
    this.activatePanel(clickedPanel);
  }

  activatePanel(panel) {
    panel.setAttribute("aria-expanded", "true");
    const currentPath = window.location.pathname;
    const panelUrl = panel.dataset.url;

    // Create or find frame
    let frame = panel.querySelector("turbo-frame") || this.createFrame(panel);

    // Determine URL to load (nested path or base panel URL)
    const urlToLoad = currentPath.startsWith(panelUrl) ? currentPath : panelUrl;

    // Always load if:
    // 1. Never loaded before, or
    // 2. Current path is different from what's loaded
    if (!panel.dataset.loaded || panel.dataset.loadedUrl !== urlToLoad) {
      panel.dataset.loaded = "true";
      panel.dataset.loadedUrl = urlToLoad;

      Turbo.visit(urlToLoad, {
        frame: "main-content",
        action: "advance",
      });
    }
  }

  createFrame(panel) {
    const frame = document.createElement("turbo-frame");
    frame.id = "main-content";
    panel.appendChild(frame);
    return frame;
  }

  deactivatePanel(panel) {
    panel.setAttribute("aria-expanded", "false");
    // Clear the loaded flag if you want to allow reloading on reactivation
    panel.dataset.loaded = "";
    panel.querySelector("turbo-frame")?.remove();
  }
}
