// app/javascript/controllers/fade_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];

  connect() {
    console.log("Stimulus: fade controller connected.");
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          // Only fade out if we have scrolled from the top
          if (
            window.pageYOffset > 0 &&
            entry.boundingClientRect.top < window.innerHeight * 0.1
          ) {
            this.contentTarget.classList.add("faded-out");
          } else {
            this.contentTarget.classList.remove("faded-out");
          }
        });
      },
      { threshold: 0 } // trigger as soon as any part moves past
    );
    this.observer.observe(this.contentTarget);
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect();
    }
  }
}
