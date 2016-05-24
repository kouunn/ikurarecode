require 'test_helper'

class NokogiriControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get search_result" do
    get :search_result
    assert_response :success
  end

end
