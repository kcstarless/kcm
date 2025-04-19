import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  static targets = [
    "postcodeResult",
    "deliveryRadio",
    "dateTime",
    "options",
    "loadingSpinner",
    "loadingSpinnerSave",
    "info",
    "continueBtn",
    "saveBtn",
  ];

  connect() {
    console.log("Delivery controller connected");
    this.validPostcode = false;

    // Listen for the modalClosed event
    document.addEventListener("modalClosed", this.resetView.bind(this));

    // Add event listeners for radio buttons
    const radioButtons = document.querySelectorAll(
      'input[name="delivery_option"]'
    );
    radioButtons.forEach((radio) => {
      radio.addEventListener(
        "change",
        this.handleDeliveryOptionChange.bind(this)
      );
    });
  }

  disconnect() {
    console.log("Delivery controller disconnected");

    // Remove event listeners
    document.removeEventListener("modalClosed", this.resetView.bind(this));

    const radioButtons = document.querySelectorAll(
      'input[name="delivery_option"]'
    );
    radioButtons.forEach((radio) => {
      radio.removeEventListener(
        "change",
        this.handleDeliveryOptionChange.bind(this)
      );
    });
  }

  // Handle radio button changes
  handleDeliveryOptionChange(event) {
    const selectedOption = event.target.value;
    console.log(`Delivery option changed to: ${selectedOption}`);

    // If pickup is selected, no need to validate postcode
    if (selectedOption === "pickup") {
      this.enableContinueButton();
    } else {
      // If delivery is selected, check if postcode has been validated
      this.validateDeliveryOption();
    }
  }

  // Check if continue button should be enabled based on current selections
  validateDeliveryOption() {
    const selectedRadio = document.querySelector(
      'input[name="delivery_option"]:checked'
    );

    if (!selectedRadio) {
      this.disableContinueButton();
      return;
    }

    if (selectedRadio.value === "delivery" && !this.validPostcode) {
      this.disableContinueButton();
    } else {
      this.enableContinueButton();
    }
  }

  enableContinueButton() {
    if (this.hasContinueBtnTarget) {
      this.continueBtnTarget.classList.remove("hidden");
      this.infoTarget.classList.add("hidden");
    }
  }

  disableContinueButton() {
    if (this.hasContinueBtnTarget) {
      this.continueBtnTarget.classList.add("hidden");
      this.infoTarget.classList.remove("hidden");
    }
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
        this.enableContinueButton();
      } else {
        this.validPostcode = false;
        this.postcodeResultTarget.innerHTML =
          result.message || "Invalid postcode.";
        this.disableContinueButton();
      }
    } catch (error) {
      console.error("Error checking postcode:", error);
      this.postcodeResultTarget.innerHTML =
        "An error occurred. Please try again.";
      this.validPostcode = false;
      this.disableContinueButton();
    } finally {
      this.loadingSpinnerTarget.classList.add("hidden");

      // Revalidate the delivery option after postcode check
      this.validateDeliveryOption();
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

    this.continueBtnTarget.classList.add("hidden");
    this.saveBtnTarget.classList.remove("hidden");

    // Hide options and show date-time container
    this.optionsTarget.classList.add("hidden");
    this.dateTimeTarget.classList.remove("hidden");
    this.dateTimeTarget.classList.add("visible");
  }

  save(event) {
    event.preventDefault();
    this.saveBtnTarget.classList.add("hidden");
    // Get selected delivery method
    const selectedRadio = document.querySelector(
      'input[name="delivery_option"]:checked'
    );
    if (!selectedRadio) {
      alert("Please select a delivery method.");
      return;
    }

    // Get the delivery method value
    const deliveryMethod = selectedRadio.value;

    // For delivery option, get the postcode
    let postcode = null;
    if (deliveryMethod === "delivery") {
      postcode = document.querySelector(".postcode").value;
      if (!this.validPostcode) {
        alert("Please enter a valid postcode.");
        return;
      }
    }

    // Get date and time from the datetimepicker
    const datetimepickerController =
      this.application.getControllerForElementAndIdentifier(
        document.querySelector("[data-controller='datetimepicker']"),
        "datetimepicker"
      );

    let selectedDate = null;
    let selectedTime = null;

    if (
      datetimepickerController &&
      typeof datetimepickerController.getSelectedValues === "function"
    ) {
      const values = datetimepickerController.getSelectedValues();
      selectedDate = values.date;
      selectedTime = values.time;
    }

    if (!selectedDate || !selectedTime) {
      alert("Please select both a date and time.");
      return;
    }

    // Prepare the data to send to the server
    const data = {
      cart: {
        delivery_method: deliveryMethod,
        // postcode: postcode,
        date_slot: selectedDate,
        time_slot: selectedTime,
      },
    };

    // Send the data to the server
    this.saveToServer(data);
  }

  async saveToServer(data) {
    try {
      // Show the save spinner
      if (this.hasLoadingSpinnerSaveTarget) {
        this.loadingSpinnerSaveTarget.classList.remove("hidden");
        console.log("Save spinner shown");
      } else {
        console.error("Save spinner target not found");
      }

      // Record the start time to ensure spinner shows for at least 1 second
      const startTime = Date.now();

      const csrfToken = document.querySelector(
        "meta[name='csrf-token']"
      ).content;

      const response = await fetch("/cart/update_delivery", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        // Turbo Stream response
        const html = await response.text();

        // Calculate elapsed time and wait if necessary to ensure 1s minimum display time
        const elapsedTime = Date.now() - startTime;
        const remainingTime = Math.max(0, 3000 - elapsedTime); // 1000ms = 1s

        // Wait for the remaining time before processing the response
        await new Promise((resolve) => setTimeout(resolve, remainingTime));

        // Now process the response after the delay
        Turbo.renderStreamMessage(html);
      } else {
        alert("Server error. Please try again.");
      }
    } catch (error) {
      console.error("Error saving delivery information:", error);
      alert("An error occurred. Please try again.");
    } finally {
      // Hide the spinner and close the modal
      if (this.hasLoadingSpinnerSaveTarget) {
        this.loadingSpinnerSaveTarget.classList.add("hidden");
        this.closeModal();
      }
    }
  }

  closeModal() {
    // Reset the form
    this.resetView();

    // Dispatch a custom event for closing the modal
    const closeEvent = new CustomEvent("closeDeliveryModal", {
      bubbles: true,
      detail: { source: "delivery" },
    });

    document.dispatchEvent(closeEvent);
  }

  resetView() {
    console.log("Resetting delivery form view"); // Debugging log

    // Ensure the options section is visible
    this.optionsTarget.classList.remove("hidden");

    // Hide the date-time section
    this.dateTimeTarget.classList.add("hidden");
    this.dateTimeTarget.classList.remove("visible");

    // Reset the form button & info states
    this.continueBtnTarget.classList.add("hidden");
    this.saveBtnTarget.classList.add("hidden");
    this.infoTarget.classList.remove("hidden");

    // Reset radio buttons - uncheck all options
    const radioButtons = document.querySelectorAll(
      'input[name="delivery_option"]'
    );
    radioButtons.forEach((radio) => {
      radio.checked = false;
    });

    // Reset the postcode input field
    const postcodeInput = document.querySelector(".postcode");
    if (postcodeInput) {
      postcodeInput.value = "";
    }

    // Clear any previous results or errors
    if (this.postcodeResultTarget) {
      this.postcodeResultTarget.innerHTML = "";
    }

    // Reset the validPostcode state
    this.validPostcode = false;
  }
}
