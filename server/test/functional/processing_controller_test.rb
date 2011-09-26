require 'test_helper'

class ProcessingControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get start" do
    get :start
    assert_response :success
  end

end
