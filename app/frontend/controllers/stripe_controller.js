import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "element",
    "cardName",
    "errors",
    "paymentMethodId",
    "submitButton",
  ];
  static formTarget = "form";

  connect() {
    console.log("Stripe controller connected");
    this.loadStripe();
  }

  loadStripe() {
    // Load Stripe.js dynamically if it's not already loaded
    if (window.Stripe) {
      this.initializeStripe();
    } else {
      const script = document.createElement("script");
      script.src = "https://js.stripe.com/v3/";
      script.onload = () => this.initializeStripe();
      document.head.appendChild(script);
    }
  }

  initializeStripe() {
    try {
      // Get the publishable key from data attribute (which will be set from Rails credentials)
      const stripeKey = document
        .querySelector('meta[name="stripe-key"]')
        ?.getAttribute("content");

      if (!stripeKey) {
        console.error("Missing Stripe publishable key!");
        this.showError("Payment form configuration error: Missing API key");
        return;
      }

      this.stripe = Stripe(stripeKey);
      this.elements = this.stripe.elements();

      // Create the card element with customized fields
      this.card = this.elements.create("card", {
        style: {
          base: {
            fontSize: "16px",
            color: "#32325d",
            fontFamily:
              "-apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif",
            "::placeholder": {
              color: "#aab7c4",
            },
          },
          invalid: {
            color: "#fa755a",
            iconColor: "#fa755a",
          },
        },
        // Hide the postal code field
        hidePostalCode: true,
      });

      // Mount the card element
      this.card.mount(this.elementTarget);

      // Handle real-time validation errors
      this.card.on("change", (event) => {
        if (event.error) {
          this.showError(event.error.message);
        } else {
          this.clearError();
        }
      });

      // Find the closest form element
      const form = this.element.closest("form");
      if (!form) {
        console.error("Could not find form element");
        return;
      }

      // Handle form submission
      form.addEventListener("submit", this.handleSubmit.bind(this));
    } catch (error) {
      console.error("Stripe initialization error:", error);
      this.showError("Failed to initialize payment form: " + error.message);
    }
  }

  handleSubmit(event) {
    event.preventDefault();

    // Disable the submit button to prevent multiple submissions
    this.submitButtonTarget.disabled = true;
    this.submitButtonTarget.value = "Processing...";

    // Create a payment method with the card and billing details
    this.stripe
      .createPaymentMethod({
        type: "card",
        card: this.card,
        billing_details: {
          name: this.cardNameTarget.value,
        },
      })
      .then((result) => {
        if (result.error) {
          // Show error in the form
          this.showError(result.error.message);
          this.submitButtonTarget.disabled = false;
          this.submitButtonTarget.value = "Complete Order";
        } else {
          // Set the payment method ID and submit the form
          this.paymentMethodIdTarget.value = result.paymentMethod.id;
          console.log("Payment method created:", result.paymentMethod.id);

          // Use Rails UJS/Turbo to submit the form instead of native submit
          // This preserves the Turbo Stream behavior
          const form = event.target;
          const formData = new FormData(form);

          // Set the correct Accept header for Turbo Stream
          fetch(form.action, {
            method: form.method || "post",
            body: formData,
            headers: {
              Accept:
                "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
              "X-Requested-With": "XMLHttpRequest",
            },
            credentials: "same-origin",
          })
            .then((response) => {
              if (response.redirected) {
                window.location.href = response.url;
              } else if (
                response.headers
                  .get("Content-Type")
                  ?.includes("text/vnd.turbo-stream.html")
              ) {
                return response.text().then((html) => {
                  Turbo.renderStreamMessage(html);
                });
              } else {
                return response.text().then((html) => {
                  // For non-turbo responses
                  document.documentElement.innerHTML = html;
                });
              }
            })
            .catch((error) => {
              console.error("Form submission error:", error);
              this.showError("Failed to process payment: " + error.message);
              this.submitButtonTarget.disabled = false;
              this.submitButtonTarget.value = "Complete Order";
            });
        }
      });
  }

  showError(message) {
    this.errorsTarget.textContent = message;
    this.errorsTarget.classList.remove("hidden");
  }

  clearError() {
    this.errorsTarget.textContent = "";
    this.errorsTarget.classList.add("hidden");
  }
}
