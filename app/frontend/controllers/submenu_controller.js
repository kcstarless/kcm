import { Controller } from "@hotwired/stimulus";

// List of submenu items for each menu item
const submenuList = [
  {
    title: "Visit Us",
    list: [
      { title: "Visit Us", path: "/visitus", target: "visitus-content" },
      { title: "Parking", path: "" },
      { title: "Accessibility", path: "" },
      { title: "Contact", path: "" },
      { title: "Education", path: "" },
      { title: "About", path: "" },
      { title: "Sustainability", path: "" },
      { title: "Restoring & Revitalising the Market", path: "" },
    ],
  },

  {
    title: "Our Traders",
    list: [
      {
        title: "Meet Our Traders",
        path: "/ourtraders",
        target: "ourtraders-content",
      },
      { title: "Meet the Market's Freshest Face", path: "" },
    ],
  },
];

export default class extends Controller {
  static targets = ["submenuModal", "submenuTitle", "submenuList"];

  connect() {
    console.log("Stimulus: submenu controller connected.");
  }
  openSubmenu(e) {
    e.preventDefault();

    const color = e.currentTarget.dataset.color;

    if (color) {
      this.submenuModalTarget.style.backgroundColor = color; // Apply parents background color
    }

    console.log("Triggered");
    this.submenuModalTarget.classList.add("active");

    const submenuTitle = e.currentTarget.dataset.title; // e.g. "Visit Us"
    const submenuData = submenuList.find(
      (submenu) => submenu.title === submenuTitle
    );

    if (submenuData) {
      // Parent menu title menu
      this.submenuTitleTarget.textContent = submenuData.title;
      // Display submenu
      const list = submenuData.list
        .map((menu) => {
          return `<div class="submenu-item">
                    <a href="${menu.path}" 
                        data-turbo-frame="main-content-mobile" 
                        data-action="click->submenu#closeSubmenu click->header#closeMenu" 
                        data-turbo-action="advance">
                        <p>${menu.title}</p>
                    </a>    
                </div>`;
        })
        .join("");
      this.submenuListTarget.innerHTML = list;
    }
  }

  closeSubmenu() {
    this.submenuModalTarget.classList.add("closing");

    // Listen for the end of the animation to hide the modal
    this.submenuModalTarget.addEventListener(
      "animationend",
      () => {
        this.submenuModalTarget.classList.remove("active", "closing");
      },
      { once: true }
    );
  }
}
