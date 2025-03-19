import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menuList", "logo", "searchIcon", "shoppingIcon"];

  connect() {
    console.log("Stimulus: header controller connected.");
    document.addEventListener("turbo:load", () => {
      this.updateLogo();
      this.updateIcons();
    });
    window.addEventListener("scroll", this.onScroll.bind(this));
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll.bind(this));
  }

  onScroll() {
    if (window.scrollY > 100) {
      this.element.classList.add("small");
    } else {
      this.element.classList.remove("small");
    }
  }

  updateIcons() {
    const path = window.location.pathname;
    if (this.hasSearchIconTarget) {
      this.searchIconTarget.src =
        path !== "/home"
          ? this.searchIconTarget.dataset.lightPath
          : this.searchIconTarget.dataset.darkPath;
    }
    if (this.hasShoppingIconTarget) {
      this.shoppingIconTarget.src =
        path !== "/home"
          ? this.shoppingIconTarget.dataset.lightPath
          : this.shoppingIconTarget.dataset.darkPath;
    }
  }

  updateLogo() {
    const path = window.location.pathname;
    const logo = this.logoTarget;
    logo.src =
      path !== "/home" ? logo.dataset.lightPath : logo.dataset.darkPath;
  }

  toggleOpenMenu(event) {
    event.preventDefault();

    if (this.menuListTarget.classList.contains("opened")) {
      this.menuListTarget.classList.add("closing");

      // Wait for the fade-out animation to complete before hiding the menu
      setTimeout(() => {
        this.menuListTarget.classList.remove("opened", "closing");
        this.menuListTarget.style.display = "none";
      }, 1000); // Matches the CSS animation duration
    } else {
      this.menuListTarget.style.display = "grid";
      this.menuListTarget.classList.add("opened");
    }
  }

  closeMenu() {
    this.menuListTarget.classList.add("closing");

    setTimeout(() => {
      this.menuListTarget.classList.remove("opened", "closing");
      this.menuListTarget.style.display = "none";
    }, 1); // Matches the CSS animation duration
  }
}
