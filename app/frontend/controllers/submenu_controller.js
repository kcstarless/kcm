import { Controller } from "@hotwired/stimulus";
import { menu } from "./consts/const_menu"; // Adjust the path according to your project structure

export default class extends Controller {
  static targets = [
    "modal",
    "title",
    "list",
    "desktopSubmenu",
    "modalContainer",
    "modalBody",
  ];

  connect() {
    console.log("Stimulus: submenu controller connected.");
    this.desktopSubmenuBar();
  }

  openSubmenu(e) {
    e.preventDefault();

    const color = e.currentTarget.dataset.color;

    if (color) {
      this.modalTarget.style.backgroundColor = color; // Apply parent's background color
    }

    this.modalTarget.classList.add("active");

    const title = e.currentTarget.dataset.title; // e.g. "Visit Us"
    const submenuList = menu.find((submenu) => submenu.title === title);
    // Parent menu title menu
    this.titleTarget.textContent = submenuList.title;
    this.submenu(submenuList, false);
  }

  closeSubmenu(e) {
    const url = e.currentTarget.href;
    console.log(url);

    const submenuLinkEvent = new CustomEvent("submenuLinkedClicked", {
      detail: { url },
    });
    document.dispatchEvent(submenuLinkEvent);

    this.modalTarget.classList.add("closing");

    // Listen for the end of the animation to hide the modal
    this.modalTarget.addEventListener(
      "animationend",
      () => {
        this.modalTarget.classList.remove("active", "closing");
      },
      { once: true }
    );
  }

  desktopSubmenuBar() {
    const path = window.location.pathname;
    const pathSegments = path.split("/").filter((segment) => segment);
    const submenuPath = pathSegments.length > 0 ? `/${pathSegments[0]}` : "/"; // Grab only first part of path eg. /visitus
    const submenuList = menu.find((submenu) => submenu.path === submenuPath);

    this.submenu(submenuList, true);
  }

  // Submenu list for each main menu
  submenu(submenuList, isDesktop) {
    if (submenuList) {
      // Display submenu
      const list = submenuList.list
        .map((menu) => {
          return `<div class="submenu-item">
                      <a href="${menu.path}" 
                          data-turbo-frame="${submenuList.frame}" 
                          ${
                            !isDesktop &&
                            'data-action="click->submenu#closeSubmenu click->header#closeMenu"'
                          } 
                          data-turbo-action="advance"
                          class="submenu-link">
                          <p>${menu.title}</p>
                      </a>    
                  </div>`;
        })
        .join("");
      this.listTarget.innerHTML = list;
    }
  }

  // Generic method to load content into a modal
  toggleModal(event) {
    event.preventDefault(); // Prevent the default link behavior

    const url = event.currentTarget.dataset.url; // Get the URL from the link's data-url attribute

    // Fetch the content and load it into the modal
    fetch(url)
      .then((response) => response.text())
      .then((html) => {
        this.modalBodyTarget.innerHTML = html; // Insert the content into the modal body
        this.modalContainerTarget.classList.remove("hidden"); // Show the modal
      })
      .catch((error) => {
        console.error("Error loading modal content:", error);
      });
  }

  closeModal() {
    this.modalContainerTarget.classList.add("hidden"); // Hide the modal
    this.modalBodyTarget.innerHTML = ""; // Clear the modal content
  }
}
