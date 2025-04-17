import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "postcodeResult",
    "deliveryRadio",
    "dateTime",
    "options",
    "loadingSpinner",
  ];

  connect() {
    console.log("Delivery controller connected");
    this.validPostocde = false;

    // Listen for the modalClosed event
    document.addEventListener("modalClosed", this.resetView.bind(this));
  }

  disconnect() {
    console.log("Delivery controller disconnected");

    // Remove the modalClosed event listener
    document.removeEventListener("modalClosed", this.resetView.bind(this));
  }

  async checkPostcode(event) {
    event.preventDefault(); // Prevent the form from submitting
    this.loadingSpinnerTarget.classList.remove("hidden");

    const form = event.target.closest("form"); // Get the form element
    const formData = new FormData(form); // Collect form data
    this.deliveryRadioTarget.checked = true;

    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
      });

      const result = await response.json();

      // Update validPostcode based on the server response
      if (result.valid) {
        this.validPostcode = true;
        this.postcodeResultTarget.innerHTML =
          result.message || "Postcode is valid.";
      } else {
        this.validPostcode = false;
        this.postcodeResultTarget.innerHTML =
          result.message || "Invalid postcode.";
      }
    } catch (error) {
      console.error("Error checking postcode:", error);
      this.postcodeResultTarget.innerHTML =
        "An error occurred. Please try again.";
    } finally {
      this.loadingSpinnerTarget.classList.add("hidden");
    }
  }

  async continue(event) {
    event.preventDefault();

    // Validation for delivery radio and postcode
    const selectedRadio = document.querySelector(
      'input[name="delivery_option"]:checked'
    );

    if (!selectedRadio) {
      alert("Please select a delivery method.");
      return;
    }

    if (selectedRadio.value === "delivery" && !this.validPostcode) {
      alert("Please enter a valid postcode.");
      return;
    }

    const deliveryMethod = selectedRadio.value;
    const postCode = document.querySelector(".postcode").value;

    // Hide options and show date-time container with animation
    this.optionsTarget.classList.add("hidden");
    this.dateTimeTarget.classList.remove("hidden");
    this.dateTimeTarget.classList.add("visible");
  }

  resetView() {
    console.log("Resetting delivery form view"); // Debugging log

    // Ensure the options section is visible
    this.optionsTarget.classList.remove("hidden");

    // Hide the date-time section
    this.dateTimeTarget.classList.add("hidden");
    this.dateTimeTarget.classList.remove("visible");

    // Clear any previous results or errors
    if (this.postcodeResultTarget) {
      this.postcodeResultTarget.innerHTML = "";
    }

    // Reset the validPostcode state
    this.validPostcode = false;
  }
}
