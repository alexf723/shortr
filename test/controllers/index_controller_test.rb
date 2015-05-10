require 'test_helper'

class IndexControllerTest < ActionController::TestCase
  
  test "should get home" do
    get :home
    assert_response :success
  end
  
  test "should get create" do
    post :create
    assert_response :success
  end
  
  test "should get expand" do
    get :expand
    assert_response :success
  end
  
  test "should get not_found" do
    get :not_found
    assert_response :success
  end

end
