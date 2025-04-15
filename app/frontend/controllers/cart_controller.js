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

  expandDelivery(event) {}

  // addToCart(event) {
  //   const productId = event.currentTarget.dataset.productId;
  //   const quantityElement = document.getElementById(
  //     `product-quantity-${productId}`
  //   );
  //   const quantity = parseInt(quantityElement.textContent, 10);

  //   fetch("/cart_items", {
  //     method: "POST",
  //     headers: {
  //       "Content-Type": "application/json",
  //       "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
  //         .content,
  //     },
  //     body: JSON.stringify({ product_id: productId, quantity: quantity }),
  //   })
  //     .then((response) => {
  //       if (response.ok) {
  //         alert("Product added to cart!");
  //       } else {
  //         alert("Failed to add product to cart.");
  //       }
  //     })
  //     .catch((error) => {
  //       console.error("Error adding product to cart:", error);
  //     });
  // }
}
