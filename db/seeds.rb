require 'faker'

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Delete all existing records in the correct order to avoid foreign key violations
Product.destroy_all
Shop.destroy_all
Category.destroy_all
Trader.destroy_all
Customer.destroy_all
User.destroy_all

# Create a single user
user = User.create!(
  email_address: "dave@dave.com",
  password: "1212",
  password_confirmation: "1212",
  first_name: "Dave",
  last_name: "Gim"
)

# Create the associated customer record
user.create_customer!(
  preferred_delivery_method: "delivery"
)

# Create categories
categories = %w[Vegetables Deli Seafood Meat Coffee Bakery].map do |category_name|
  Category.find_or_create_by!(name: category_name)
end

# Create shops
shops = categories.map do |category|
  shop = Shop.find_or_create_by!(
    name: "#{category.name} Shop",
    location: Faker::Address.street_address,
    phone_number: Faker::PhoneNumber.phone_number,
    email_address: Faker::Internet.email,
    description: "This is a shop specializing in #{category.name.downcase} products."
  )
  shop.image.attach(
    io: File.open(Rails.root.join("app/assets/images/shops/#{category.name.downcase}_shop.avif")), # Add :io back
    filename: "#{category.name.downcase}_shop.avif",
    content_type: "image/avif"
  )
  shop
end

# Create products for each shop
shops.each_with_index do |shop, index|
  6.times do |i|
    product = shop.products.find_or_create_by!(
      name: "#{categories[index].name} Product #{i + 1}",
      description: Faker::Food.description,
      price: Faker::Commerce.price(range: 1.0..20.0),
      stock: 100
    )
    product.categories << categories[index] unless product.categories.include?(categories[index])

    # Attach images for Vegetables products
    if categories[index].name == "Vegetables"
      product.image.attach(
        io: File.open(Rails.root.join("app/assets/images/products/products_vege#{i + 1}.avif")),
        filename: "products_vege#{i + 1}.avif",
        content_type: "image/avif"
      )
    end
  end
end

# Create 6 new users, each associated with a trader and linked to a shop
shops.each_with_index do |shop, i|
  user = User.create!(
    email_address: Faker::Internet.email,
    password: "password#{i + 1}",
    password_confirmation: "password#{i + 1}",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )

  trader = user.create_trader!
  trader.shops << shop
end

puts "Seeded database with 6 shops, categories, and 6 products per shop, each with a stock of 100."
puts "Seeded database with 6 traders, each linked to one of the 6 shops."
