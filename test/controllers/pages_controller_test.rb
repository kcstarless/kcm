require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_url
    assert_response :success
  end

  test "should get visitus" do
    get visitus_url
    assert_response :success
  end

  test "should get ourtraders" do
    get ourtraders_url
    assert_response :success
  end

  test "should get becomeatrader" do
    get becomeatrader_url
    assert_response :success
  end

  test "should get eventstours" do
    get eventstours_url
    assert_response :success
  end

  test "should get news" do
    get news_url
    assert_response :success
  end

  test "should get thenightmarket" do
    get thenightmarket_url
    assert_response :success
  end

  test "should get shop" do
    get shop_url
    assert_response :success
  end

  test "should get parking" do
    get parking_url
    assert_response :success
  end
end
