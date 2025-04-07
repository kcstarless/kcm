require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:product_one)
    @shop = shops(:shop_one)
    @category = categories(:category_one)
  end

  test "should create product with valid attributes" do
    assert @product.persisted?, "Product should be successfully created"
    assert_equal "crab", @product.name, "Product name should match"
    assert_equal 9.99, @product.price, "Product price should match"
    assert_equal 1, @product.stock, "Product stock should match"
    assert_equal @shop, @product.shop, "Product should belong to the correct shop"
  end

  test "should not create product without required attributes" do
    product = Product.new
    assert_not product.save, "Product should not be saved without required attributes"
    assert_includes product.errors[:name], "can't be blank", "Name validation should be present"
    assert_includes product.errors[:price], "can't be blank", "Price validation should be present"
    assert_includes product.errors[:shop], "must exist", "Shop validation should be present"
  end

  test "should not allow duplicate product names within the same shop" do
    duplicate_product = Product.new(name: @product.name, price: 5.99, stock: 10, shop: @shop)
    assert_not duplicate_product.save, "Product should not allow duplicate names within the same shop"
    assert_includes duplicate_product.errors[:name], "has already been taken", "Name uniqueness validation should be enforced within the same shop"
  end

  test "should allow duplicate product names in different shops" do
    other_shop = shops(:shop_two)
    duplicate_product = Product.new(name: @product.name, price: 5.99, stock: 10, shop: other_shop)
    assert duplicate_product.save, "Product should allow duplicate names in different shops"
  end

  test "should not allow negative price" do
    product = Product.new(name: "Negative Price Product", price: -1.0, stock: 10, shop: @shop)
    assert_not product.save, "Product should not allow negative price"
    assert_includes product.errors[:price], "must be greater than or equal to 0", "Price validation should enforce non-negative values"
  end

  test "should not allow invalid stock values" do
    product = Product.new(name: "Invalid Stock Product", price: 5.99, stock: nil, shop: @shop)
    assert_not product.save, "Product should not allow nil stock"
    assert_includes product.errors[:stock], "can't be blank", "Stock validation should enforce presence"

    product.stock = -1
    assert_not product.save, "Product should not allow negative stock"
    assert_includes product.errors[:stock], "must be greater than or equal to 0", "Stock validation should enforce non-negative values"
  end

  test "should have many associated categories" do
    assert_includes @product.categories, @category, "Product should include the associated category"
  end
end
