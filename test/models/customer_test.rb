require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email_address: "test_user@example.com", password: "securepassword", first_name: "Test", last_name: "User")
  end
  test "should create customer with valid attributes" do
    customer = Customer.create!(user: @user, preferred_delivery_method: "delivery")
    assert customer.persisted?, "Customer should be successfully created"
    assert_equal "delivery", customer.preferred_delivery_method, "Preferred delivery method should match"
  end

  test "should not create customer without user" do
    customer = Customer.create(preferred_delivery_method: "delivery")
    assert_not customer.persisted?, "Customer should not be created without a user"
    assert_includes customer.errors[:user], "must exist"
  end

  test "should not create customer without preferred delivery method should have default method" do
    customer = Customer.create(user: @user)
    assert customer.persisted?, "Customer should not be created without a preferred delivery method"
    assert_equal "pickup", customer.preferred_delivery_method, "Preferred delivery method should default to 'pickup'"
  end
end
