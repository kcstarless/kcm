import { Controller } from "@hotwired/stimulus";
import { menu } from "./consts/const_menu"; // Adjust the path according to your project structure

export default class extends Controller {
  static targets = ["title", "list", "loginContainer", "modalBody"];

  connect() {
    console.log("Stimulus: submenu controller connected.");
    this.submenuBar();
  }

  // openSubmenu(e) {
  //   e.preventDefault();

  //   const color = e.currentTarget.dataset.color;

  //   if (color) {
  //     this.modalTarget.style.backgroundColor = color; // Apply parent's background color
  //   }

  //   this.modalTarget.classList.add("active");

  //   const title = e.currentTarget.dataset.title; // e.g. "Visit Us"
  //   const submenuList = menu.find((submenu) => submenu.title === title);
  //   // Parent menu title menu
  //   this.titleTarget.textContent = submenuList.title;
  //   this.submenu(submenuList, false);
  // }

  // closeSubmenu(e) {
  //   const url = e.currentTarget.href;
  //   console.log(url);

  //   const submenuLinkEvent = new CustomEvent("submenuLinkedClicked", {
  //     detail: { url },
  //   });
  //   document.dispatchEvent(submenuLinkEvent);

  //   this.modalTarget.classList.add("closing");

  //   // Listen for the end of the animation to hide the modal
  //   this.modalTarget.addEventListener(
  //     "animationend",
  //     () => {
  //       this.modalTarget.classList.remove("active", "closing");
  //     },
  //     { once: true }
  //   );
  // }

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
    this.modalBodyTarget.querySelectorAll("div").forEach((form) => {
      form.classList.add("hidden"); // Hide all forms
    });
  }
}
