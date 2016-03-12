require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get result" do
    get :result
    assert_response :success
  end

end
