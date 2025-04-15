import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["postcodeResult", "deliveryRadio"];
  connect() {
    console.log("Delivery controller connected");
  }

  async checkPostcode(event) {
    event.preventDefault(); // Prevent the form from submitting

    const form = event.target.closest("form"); // Get the form element
    const formData = new FormData(form); // Collect form data
    this.deliveryRadioTarget.checked = true;

    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
      });

      const result = await response.json();

      // Display the response in the .postcode-result div
      this.postcodeResultTarget.innerHTML =
        result.message || "Something went wrong.";
    } catch (error) {
      console.error("Error checking postcode:", error);
      this.postcodeResultTarget.innerHTML =
        "An error occurred. Please try again.";
    }
  }
}
