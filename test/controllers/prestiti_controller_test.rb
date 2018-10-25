require 'test_helper'

class PrestitiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get prestiti_index_url
    assert_response :success
  end

  test "should get show" do
    get prestiti_show_url
    assert_response :success
  end

end
