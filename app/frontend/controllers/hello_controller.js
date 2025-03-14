// app/frontend/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["output"];

  connect() {
    console.log("Hello Stimulus is connected!");
  }

  greet() {
    this.outputTarget.textContent = "Hello from Stimulus!";
  }
}
