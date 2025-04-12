import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { id: Number };

  connect() {
    console.log(`CartItemController connected for item ID: ${this.idValue}`);
  }

  increaseQuantity() {
    console.log("Increase button clicked");
    this.updateQuantity(1);
  }

  decreaseQuantity() {
    console.log("Decrease button clicked");
    this.updateQuantity(-1);
  }

  updateQuantity(change) {
    console.log(`Updating quantity by ${change}`);
    const quantityInput = this.element.querySelector(".quantity-input");
    const newQuantity = parseInt(quantityInput.value, 10) + change;

    if (newQuantity < 1) return;

    // Update the quantity visually
    quantityInput.value = newQuantity;

    // Send the update to the server
    fetch(`/cart_items/${this.idValue}`, {
      // Ensure `this.idValue` is correct
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({ quantity: newQuantity }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to update quantity");
        }
        return response.text();
      })
      .then((html) => {
        Turbo.renderStreamMessage(html); // Update the cart dynamically
      })
      .catch((error) => {
        console.error("Error updating quantity:", error);
      });
  }
}
