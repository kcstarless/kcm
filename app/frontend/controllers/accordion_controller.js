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
      const isActive = panelUrl === currentPath;
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

    let frame = panel.querySelector("turbo-frame");
    if (!frame) {
      frame = document.createElement("turbo-frame");
      frame.id = "main-content";
      panel.appendChild(frame);
    }

    // Only call Turbo.visit if this panel hasn't been loaded before.
    if (!panel.dataset.loaded) {
      panel.dataset.loaded = "true";
      const url = panel.dataset.url;
      if (url && typeof Turbo !== "undefined") {
        Turbo.visit(url, {
          frame: "main-content",
          action: "advance", // You can try "replace" if needed
        });
      }
    }
  }

  deactivatePanel(panel) {
    panel.setAttribute("aria-expanded", "false");
    // Clear the loaded flag if you want to allow reloading on reactivation
    panel.dataset.loaded = "";
    panel.querySelector("turbo-frame")?.remove();
  }
}
