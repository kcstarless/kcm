import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.remove(); // Remove the flash message after 3 seconds
    }, 3000);
  }
}
