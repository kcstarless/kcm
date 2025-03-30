import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Flash controller connected");
    console.log(this.element);
    setTimeout(() => {
      this.element.remove();
    }, 2500);
  }
}
