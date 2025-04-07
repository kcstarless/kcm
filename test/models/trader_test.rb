require "test_helper"

class TraderTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email_address: "test_user@example.com", password: "securepassword", first_name: "Test", last_name: "User")
  end
  test "should create trader with valid attributes" do
    trader = Trader.create!(user: @user)
    assert trader.persisted?, "Trader should be successfully created"
  end

  test "should not create trader without user" do
    trader = Trader.create()
    assert_not trader.persisted?, "Trader should not be created without a user"
    assert_includes trader.errors[:user], "must exist"
  end

  test "should belong to a user" do
    trader = Trader.create!(user: @user)
    assert_equal @user, trader.user, "Trader should belong to the correct user"
  end
end
