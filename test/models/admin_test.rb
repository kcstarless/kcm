require "test_helper"

class AdminTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email_address: "test_user@example.com", password: "securepassword", first_name: "Test", last_name: "User")
  end

  test "should create admin with valid enum values" do
    admin = Admin.create!(user: @user, role: "power_user")
    assert admin.persisted?, "Admin should be successfully created with a valid role"
    assert_equal "power_user", admin.role, "Admin role should match the assigned value"
    assert admin.power_user?, "Admin should respond true to power_user? helper method"

    admin.role = "root_user"
    assert admin.save, "Admin should be successfully updated with a valid role"
    assert_equal "root_user", admin.role, "Admin role should match the updated value"
    assert admin.root_user?, "Admin should respond true to root_user? helper method"
  end

  # test "should raise ArgumentError for invalid enum values" do
  #   # Check that assigning an invalid role raises ArgumentError
  #   assert_raises ArgumentError do
  #     Admin.new(user: @user, role: "invalid_role")
  #   end
  # end

  test "should provide enum helper methods" do
    admin = Admin.create!(user: @user, role: "power_user")
    assert admin.power_user?, "Admin should respond true to power_user? helper method"
    assert_not admin.root_user?, "Admin should respond false to root_user? helper method"

    admin.update!(role: "root_user")
    assert admin.root_user?, "Admin should respond true to root_user? helper method"
    assert_not admin.power_user?, "Admin should respond false to power_user? helper method"
  end

  test "should not create admin with invalid role in database" do
    # Insert an invalid role directly into the database
    Admin.connection.execute("INSERT INTO admins (user_id, role, created_at, updated_at) VALUES (#{@user.id}, 'invalid_role', NOW(), NOW())")
    admin = Admin.last

    # Reload the record and check validations
    assert_not admin.valid?, "Admin should not be valid with an invalid role"
    assert_includes admin.errors[:role], "is not included in the list"
  end

  test "should default role to power_user" do
    admin = Admin.create!(user: @user)
    assert_equal "power_user", admin.role, "Admin role should default to 'power_user'"
  end
end
