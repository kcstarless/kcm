require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "should create customer with valid attributes" do
    user = User.create!(email_address: "test_user@example.com", password: "securepassword")
    customer = Customer.create!(user: user, name: "Test Customer", preferred_delivery_method: "delivery")
    assert customer.persisted?, "Customer should be successfully created"
    assert_equal "Test Customer", customer.name, "Customer name should match"
    assert_equal "delivery", customer.preferred_delivery_method, "Preferred delivery method should match"
  end

  test "should not create customer without name" do
    user = User.create!(email_address: "test_user@example.com", password: "securepassword")
    customer = Customer.create(user: user, preferred_delivery_method: "delivery")
    assert_not customer.persisted?, "Customer should not be created without a name"
    assert_includes customer.errors[:name], "can't be blank"
  end

  test "should not create customer without user" do
    customer = Customer.create(name: "Test Customer", preferred_delivery_method: "delivery")
    assert_not customer.persisted?, "Customer should not be created without a user"
    assert_includes customer.errors[:user], "must exist"
  end

  test "should belong to a user" do
    user = User.create!(email_address: "test_user@example.com", password: "securepassword")
    customer = Customer.create!(user: user, name: "Test Customer", preferred_delivery_method: "delivery")
    assert_equal user, customer.user, "Customer should belong to the correct user"
  end

  test "should not create customer with invalid delivery method" do
    user = User.create!(email_address: "test_user@example.com", password: "securepassword")
    customer = Customer.create(user: user, name: "Test Customer", preferred_delivery_method: "invalid_method")
    assert_not customer.persisted?, "Customer should not be created with an invalid delivery method"
    assert_includes customer.errors[:preferred_delivery_method], "is not included in the list"
  end
end
