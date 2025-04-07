require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = categories(:category_one)
    @product = products(:product_one)
    @shop = shops(:shop_one)
  end

  test "should create category with valid attributes" do
    assert @category.persisted?, "Category should be successfully created"
    assert_equal "Seafood", @category.name, "Category name should match"
  end

  test "should not create category without a name" do
    category = Category.new
    assert_not category.save, "Category should not be saved without a name"
    assert_includes category.errors[:name], "can't be blank", "Name validation should be present"
  end

  test "should not allow duplicate category names" do
    duplicate_category = Category.new(name: @category.name)
    assert_not duplicate_category.save, "Category should not allow duplicate names"
    assert_includes duplicate_category.errors[:name], "has already been taken", "Name uniqueness validation should be enforced"
  end

  test "should have many associated products" do
    assert_includes @category.products, @product, "Category should include the associated product"
  end

  test "should have many associated shops" do
    assert_includes @category.shops, @shop, "Category should include the associated shop"
  end
end
