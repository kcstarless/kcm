require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create(email_address: "test_user@example.com", password: "securepassword", first_name: "Test", last_name: "User")
    @user_no_first_name = User.create(email_address: "test_user@example.com", password: "securepassword", last_name: "User")
    @user_no_last_name = User.create(email_address: "test_user@example.com", password: "securepassword", first_name: "Test")
    # User.destroy_all
  end

  test "should create user with valid attributes" do
    assert @user.persisted?, "User should be successfully created"
    assert_equal "test_user@example.com", @user.email_address, "User email address should match"
  end

  test "should not create user without first name" do
    assert_not @user_no_first_name.valid?, "User should not be valid without a first name"
    assert_includes @user_no_first_name.errors[:first_name], "can't be blank"
  end

  test "should not create user without last name" do
    assert_not @user_no_last_name.valid?, "User should not be valid without a last name"
    assert_includes @user_no_last_name.errors[:last_name], "can't be blank"
  end

  test "should not create user without email" do
    user = User.new(password: "securepassword")
    assert_not user.valid?, "User should not be valid without an email"
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should not create user with duplicate email" do
    user = User.create(email_address: "test_user@example.com", password: "securepassword", first_name: "Test", last_name: "User")
    assert_not user.valid?, "User should not be valid with a duplicate email"
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "should have one associated customer" do
    # Simulate the behavior of the RegistrationsController
    @user.create_customer!(preferred_delivery_method: "pickup")

    # Verify the associated customer
    customer = @user.customer
    assert_not_nil customer, "Customer should be created automatically"
    assert_equal "pickup", customer.preferred_delivery_method, "Preferred delivery method should match the default"
  end

  test "should find user from fixtures" do
    user = users(:one) # Load the `one_user` fixture
    assert_equal "user_one@example.com", user.email_address
  end
end
