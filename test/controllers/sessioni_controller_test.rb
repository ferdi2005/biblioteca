require 'test_helper'

class SessioniControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sessioni_new_url
    assert_response :success
  end

end
