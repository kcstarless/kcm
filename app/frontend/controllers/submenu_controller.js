import { Controller } from "@hotwired/stimulus";
import { menu } from "./consts/const_menu"; // Adjust the path according to your project structure

export default class extends Controller {
  static targets = [
    "title",
    "list",
    "loginContainer",
    "modalBody",
    "modalDelivery",
    "modalCheckout",
  ];

  connect() {
    console.log("Stimulus: submenu controller connected.");
    this.submenuBar();

    // Listen for custom closeDeliveryModal event from the delivery controller
    document.addEventListener(
      "closeDeliveryModal",
      this.closeDeliveryModal.bind(this)
    );
  }

  disconnect() {
    // Clean up event listeners
    document.removeEventListener(
      "closeDeliveryModal",
      this.closeDeliveryModal.bind(this)
    );
  }

  submenuBar() {
    const path = window.location.pathname;
    const pathSegments = path.split("/").filter((segment) => segment);
    const submenuPath = pathSegments.length > 0 ? `/${pathSegments[0]}` : "/"; // Grab only first part of path eg. /visitus
    const submenuList = menu.find((submenu) => submenu.path === submenuPath);

    this.submenu(submenuList, path);
  }

  // Submenu list for each main menu
  submenu(submenuList, path) {
    if (submenuList) {
      // Display submenu
      const list = submenuList.list
        .map((menu) => {
          return `<div class="submenu-item ${
            path === menu.path ? "active" : ""
          }">
                      <a href="${menu.path}" 
                          data-turbo-frame="${submenuList.frame}" 
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

  // Method to load Login, Register, delivery
  toggleModal(event) {
    event.preventDefault();
    const target = event.currentTarget.dataset.target;

    // Remove active class from all forms
    this.modalBodyTarget
      .querySelectorAll("#loginForm, #registerForm, #deliveryForm, #cartForm")
      .forEach((form) => {
        form.classList.remove("active");
      });

    // Add active class to target form
    const formToShow = this.modalBodyTarget.querySelector(`#${target}Form`);
    if (formToShow) {
      formToShow.classList.add("active");
    }

    // Show modal container
    this.loginContainerTarget.classList.remove("hidden");
  }

  closeModal() {
    this.loginContainerTarget.classList.add("hidden"); // Hide the modal

    // Reset all forms inside the modal
    this.modalBodyTarget.querySelectorAll("div").forEach((form) => {
      form.classList.add("hidden"); // Hide all forms
    });

    // Dispatch a custom event to trigger reset logic in other controllers
    const resetEvent = new Event("modalClosed");
    document.dispatchEvent(resetEvent);
  }

  // Load delivery form modal
  toggleDeliveryModal(event) {
    event.preventDefault();
    // this.closeModal();
    this.modalDeliveryTarget.classList.remove("hidden");
  }
  closeDeliveryModal(event) {
    event.preventDefault();
    this.modalDeliveryTarget.classList.add("hidden"); // Hide the modal
  }

  // Load checkout modal
  toggleCheckoutModal(event) {
    event.preventDefault();
    this.modalCheckoutTarget.classList.remove("hidden");
  }

  closeCheckoutModal(event) {
    event.preventDefault();
    this.modalCheckoutTarget.classList.add("hidden"); // Hide the modal
  }
}
