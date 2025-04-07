require "test_helper"

class ShopTest < ActiveSupport::TestCase
  setup do
    @shop = shops(:shop_one)
    @category = categories(:category_one)
    @product = products(:product_one)
  end

  test "should create shop with valid attributes" do
    assert @shop.persisted?, "Shop should be successfully created"
    assert_equal "Test Shop One", @shop.name, "Shop name should match"
    assert_equal "123 Market St", @shop.location, "Shop location should match"
    assert_equal "123-456-7890", @shop.phone_number, "Shop phone number should match"
    assert_equal "test1@shop.com", @shop.email_address, "Shop email address should match"
  end

  test "should have associated products" do
    assert_includes @shop.products, @product, "Shop should include the associated product"
  end

  test "should have multiple associated categories" do
    assert_includes @shop.categories, @category, "Shop should include the first associated category"
    assert_includes @shop.categories, categories(:category_two), "Shop should include the second associated category"
  end

  # test "should destroy associated products when shop is destroyed" do
  #   assert_difference("Product.count", -@shop.products.count) do
  #     @shop.destroy
  #   end
  # end

  # test "should destroy associated categories when shop is destroyed" do
  #   assert_difference("@shop.categories.count", -@shop.categories.count) do
  #     @shop.destroy
  #   end
  # end

  test "should not create shop without required attributes" do
    shop = Shop.new # No attributes provided
    assert_not shop.save, "Shop should not be saved without required attributes"
    assert_includes shop.errors[:name], "can't be blank", "Name validation should be present"
    assert_includes shop.errors[:location], "can't be blank", "Location validation should be present"
    assert_includes shop.errors[:phone_number], "can't be blank", "Phone number validation should be present"
    assert_includes shop.errors[:email_address], "can't be blank", "Email address validation should be present"
  end

  test "should not allow duplicate shop names" do
    duplicate_shop = Shop.new(name: @shop.name, location: "New Location", phone_number: "987-654-3210", email_address: "duplicate@shop.com")
    assert_not duplicate_shop.save, "Shop should not allow duplicate names"
    assert_includes duplicate_shop.errors[:name], "has already been taken", "Name uniqueness validation should be enforced"
  end

  test "should not allow invalid email format" do
    shop = Shop.new(name: "Invalid Email Shop", location: "123 Invalid St", phone_number: "123-456-7890", email_address: "invalid-email")
    assert_not shop.save, "Shop should not allow invalid email format"
    assert_includes shop.errors[:email_address], "is invalid", "Email format validation should be enforced"
  end

  test "should not allow excessively long names" do
    shop = Shop.new(name: "A" * 256, location: "123 Long Name St", phone_number: "123-456-7890", email_address: "longname@shop.com")
    assert_not shop.save, "Shop should not allow excessively long names"
    assert_includes shop.errors[:name], "is too long (maximum is 255 characters)", "Name length validation should be enforced"
  end

  test "should have many categories" do
    assert_equal 2, @shop.categories.count, "Shop should have two associated categories"
    assert_includes @shop.categories, @category, "Shop should include the first associated category"
    assert_includes @shop.categories, categories(:category_two), "Shop should include the second associated category"
  end

  test "should have many products" do
    assert_equal 2, @shop.products.count, "Shop should have one associated product"
    assert_includes @shop.products, @product, "Shop should include the associated product"
  end
end
