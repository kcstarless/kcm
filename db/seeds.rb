# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Delete all existing users and associated records
User.destroy_all
Customer.destroy_all

# Create a single user
user = User.create!(
  email_address: "kcm@kcm.com",
  password: "1212",
  password_confirmation: "1212"
)

# Create the associated customer record
user.create_customer!(
  name: "King Charles",
  preferred_delivery_method: "delivery"
)

puts "Seeded database with a single user and associated customer."
