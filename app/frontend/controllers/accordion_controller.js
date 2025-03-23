import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panelContainer"];

  connect() {
    this.initializePanels();
    // Event listener from submenu
    document.addEventListener(
      "submenuLinkedClicked",
      this.handleSubmenuLinkClicked.bind(this)
    );
  }

  disconnect() {
    // Clean up the event listener
    document.removeEventListener(
      "submenuLinkClicked",
      this.handleSubmenuLinkClicked.bind(this)
    );
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
        // const link = container.querySelector("a");
        // if (link) {
        //   link.click(); // Active content inside the accordion panel
        // }
      } else {
        this.deactivatePanel(panel);
      }
    });
  }

  // Home logo toggle
  toggleHome() {
    window.location.href = "/home";
  }

  // Active a panel
  toggle(event) {
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
    const currentPath = window.location.pathname;
    panel.setAttribute("aria-expanded", "true");
    const frameId = panel.getAttribute("aria-controls");
    const frame = document.getElementById(frameId);
    if (frame && !frame.innerHTML.trim()) {
      // Set the content of frame to current path
      frame.src = currentPath;
    }
  }

  deactivatePanel(panel) {
    panel.setAttribute("aria-expanded", "false");
    const content = panel.querySelector(".content");
    if (content) {
      content.innerHTML = "";
    }
  }

  handleSubmenuLinkClicked(e) {
    const url = new URL(e.detail.url);
    const path = url.pathname;
    this.activatePanelByPath(path);
  }

  // Mobile submenu activation trigger
  activatePanelByPath(path) {
    this.panelContainerTargets.forEach((container) => {
      const panel = container.querySelector(".panel");
      const panelUrl = panel.dataset.url;
      const isActive = path.startsWith(panelUrl);

      if (isActive) {
        this.activatePanel(panel);
      } else {
        this.deactivatePanel(panel);
      }
    });
  }
}
