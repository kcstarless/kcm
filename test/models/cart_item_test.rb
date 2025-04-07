require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:cart_one)
    @cart_item_one = cart_items(:cart_item_one)
  end

  test "should not allow duplicate cart items in the same cart" do
    duplicate_cart_item = CartItem.new(cart: @cart, product: @cart_item_one.product, quantity: 2)
    assert_not duplicate_cart_item.save, "Cart item should not allow duplicates in the same cart"
    assert_includes duplicate_cart_item.errors[:product_id], "has already been taken", "Product uniqueness validation should be enforced within the same cart"
  end
  test "should not allow negative quantity" do
    cart_item = CartItem.new(cart: @cart, product: products(:product_three), quantity: -1)
    assert_not cart_item.save, "Cart item should not allow negative quantity"
    assert_includes cart_item.errors[:quantity], "must be greater than or equal to 0", "Quantity validation should enforce non-negative values"
  end

  test "should calculate item subtotal" do
    cart_item = CartItem.create!(cart: @cart, product: products(:product_four), quantity: 2)

    expected_subtotal = cart_item.product.price * cart_item.quantity
    assert_equal expected_subtotal, cart_item.item_subtotal, "Item subtotal should match the product price multiplied by quantity"
  end

  test "should set price before creating cart item" do
    cart_item = CartItem.new(cart: @cart, product: products(:product_five), quantity: 3)
    cart_item.save
    assert_equal cart_item.product.price, cart_item.price, "Price should be set to the product price before creating the cart item"
  end

  test "should not set price if already set" do
    cart_item = CartItem.create!(cart: @cart, product: products(:product_six), quantity: 2, price: 10.0)
    assert_equal 10.0, cart_item.price, "Price should not be overridden if already set"
  end

  test "should belong to a cart" do
    cart_item = CartItem.new(cart: @cart, product: products(:product_four), quantity: 1)
    assert cart_item.cart, "Cart item should belong to a cart"
  end
end
