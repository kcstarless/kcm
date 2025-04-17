import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Cart controller connected");
  }

  increaseQuantity(event) {
    const productId = event.currentTarget.dataset.productId;
    const quantityElement = document.getElementById(
      `product-quantity-${productId}`
    );
    const hiddenField = document.getElementById(`quantity-input-${productId}`);
    let currentQuantity = parseInt(quantityElement.textContent, 10);

    // Increment the quantity
    currentQuantity += 1;
    quantityElement.textContent = currentQuantity;

    // Update the hidden field value
    hiddenField.value = currentQuantity;
  }

  decreaseQuantity(event) {
    const productId = event.currentTarget.dataset.productId;
    const quantityElement = document.getElementById(
      `product-quantity-${productId}`
    );
    const hiddenField = document.getElementById(`quantity-input-${productId}`);
    let currentQuantity = parseInt(quantityElement.textContent, 10);

    // Decrement the quantity if greater than 1
    if (currentQuantity > 1) {
      currentQuantity -= 1;
      quantityElement.textContent = currentQuantity;

      // Update the hidden field value
      hiddenField.value = currentQuantity;
    }
  }
}
