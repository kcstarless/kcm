import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["mobile"];

  connect() {
    console.log("Layout controller connected");
    this.updateLayout();
    this.mirrorToMobile();
    window.addEventListener("resize", this.updateLayout.bind(this));
    document.addEventListener("turbo:load", this.handleTurboLoad.bind(this));
  }

  disconnect() {
    window.removeEventListener("resize", this.updateLayout);
    document.removeEventListener("turbo:load", this.handleTurboLoad);
  }

  updateLayout() {
    const isDesktop = window.innerWidth >= 1500;
    this.mobileTarget.style.display = isDesktop ? "none" : "block";

    // Sync accordion after layout change
    if (isDesktop) this.syncDesktopAccordion();
  }

  handleTurboLoad = () => {
    // Sync accordion after any navigation
    if (window.innerWidth >= 1500) this.syncDesktopAccordion();
  };

  mirrorToMobile() {
    // Listen for Turbo Frame updates on the desktop frame
    this.handleFrameLoad = (event) => {
      if (event.target.id === "main-content") {
        const mobileFrame = document.getElementById("main-content-mobile");
        if (mobileFrame) {
          // Mirror desktop content to mobile frame
          mobileFrame.innerHTML = event.target.innerHTML;
        }
      }
    };

    document.addEventListener("turbo:frame-load", this.handleFrameLoad);
  }

  syncDesktopAccordion() {
    const currentPath = window.location.pathname;
    const panelLink = document.querySelector(
      `.accordion-panel a[href="${currentPath}"]`
    );

    if (panelLink) {
      const panel = panelLink.closest(".panel");
      if (panel.getAttribute("aria-expanded") === "false") {
        // Let Turbo handle the frame update
        Turbo.visit(panelLink.href, {
          frame: "main-content",
          action: "advance", // Changed from "replace"
        });
      }
    }
  }
}
