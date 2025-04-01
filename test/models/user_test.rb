require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Remove the setup block since fixtures handle test data
  # setup do
  #   User.destroy_all
  # end

  test "should create user with valid attributes" do
    user = User.create(email_address: "test_user@example.com", password: "securepassword")
    assert user.persisted?, "User should be successfully created"
    assert_equal "test_user@example.com", user.email_address, "User email address should match"
  end

  test "should not create user without email" do
    user = User.new(password: "securepassword")
    assert_not user.valid?, "User should not be valid without an email"
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should not create user with duplicate email" do
    User.create!(email_address: "duplicate@example.com", password: "securepassword")
    user = User.new(email_address: "duplicate@example.com", password: "securepassword")
    assert_not user.valid?, "User should not be valid with a duplicate email"
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "should have one associated customer" do
    user = User.create!(email_address: "test_user@example.com", password: "securepassword")
    # Simulate the behavior of the RegistrationsController
    user.create_customer!(name: "Tom", preferred_delivery_method: "pickup")

    # Verify the associated customer
    customer = user.customer
    assert_not_nil customer, "Customer should be created automatically"
    assert_equal "Tom", customer.name, "Customer name should match the default"
    assert_equal "pickup", customer.preferred_delivery_method, "Preferred delivery method should match the default"
  end

  test "should find user from fixtures" do
    user = users(:one_user) # Load the `one_user` fixture
    assert_equal "user_one@example.com", user.email_address
  end
end
