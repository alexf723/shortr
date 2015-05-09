require 'test_helper'

class IndexControllerTest < ActionController::TestCase
  
  test "check valid http url" do
    assert IndexController.is_valid_url( "http://www.test.com" )
  end

end
