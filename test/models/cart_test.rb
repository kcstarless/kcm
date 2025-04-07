require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:cart_one)
    @cart_item_one = cart_items(:cart_item_one)
    @cart_item_two = cart_items(:cart_item_two)
  end

  test "should calculate total price of cart items" do
    total_price = @cart.total_price
    expected_price = @cart_item_one.product.price * @cart_item_one.quantity + @cart_item_two.product.price * @cart_item_two.quantity
    assert_equal expected_price, total_price, "Cart total price should match the sum of cart item prices"
  end

  test "should calculate total items in cart" do
    total_items = @cart.total_items
    expected_items = @cart_item_one.quantity + @cart_item_two.quantity
    assert_equal expected_items, total_items, "Cart total items should match the sum of cart item quantities"
  end

  test "should not create cart without user" do
    cart = Cart.new
    assert_not cart.save, "Cart should not be saved without a user"
    assert_includes cart.errors[:user], "must exist", "User validation should be present"
  end

  test "should have many associated cart items" do
    assert_includes @cart.cart_items, @cart_item_one, "Cart should include the first associated cart item"
    assert_includes @cart.cart_items, @cart_item_two, "Cart should include the second associated cart item"
  end

  test "should have a valid status" do
    assert_includes Cart.statuses.keys, @cart.status, "Cart status should be valid"
  end

  test "should not allow invalid status" do
    cart = Cart.new(status: "invalid_status")
    assert_not cart.save, "Cart should not be saved with an invalid status"
    assert_includes cart.errors[:status], "is not included in the list", "Status validation should enforce valid statuses"
  end

  test "should destroy associated cart items when cart is destroyed" do
    assert_difference("CartItem.count", -@cart.cart_items.count) do
      @cart.destroy
    end
  end
end
