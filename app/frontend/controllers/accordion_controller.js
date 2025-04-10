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

    this.element.addEventListener("activateHomePanel", () => {
      this.activateHomePanel();
    });
  }

  disconnect() {
    // Clean up the event listener
    document.removeEventListener(
      "submenuLinkedClicked",
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

  // Active a panel
  toggle(event) {
    const clickedElement = event.currentTarget;
    const panelUrl = clickedElement.dataset.url; // Get the panel URL from the data attribute

    if (!panelUrl) {
      console.error("No panel URL specified for this submenu link.");
      return;
    }

    // Find the corresponding panel using the data-url attribute
    const panel = document.querySelector(`.panel[data-url="${panelUrl}"]`);

    if (!panel) {
      console.error(`No panel found with URL: ${panelUrl}`);
      return;
    }
    // console.log(this.panelContainerTargets);
    // Deactivate all panels
    const allPanels = document.querySelectorAll(".panel");
    allPanels.forEach((panel) => {
      this.deactivatePanel(panel);
    });

    // Always activate the clicked panel
    this.activatePanel(panel);
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
    const content = panel.querySelector(".content");
    if (content) {
      content.style.visibility = "visible"; // Shows the content
    }
  }

  deactivatePanel(panel) {
    if (!panel) {
      console.error("Panel is null or undefined in deactivatePanel.");
      return;
    }
    // console.log("Deactivating panel:", panel);
    panel.setAttribute("aria-expanded", "false");
    const content = panel.querySelector(".content");
    if (content) {
      content.style.visibility = "hidden"; // Hides the content without affecting layout
    }
  }

  // Mobile submenu click event
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
