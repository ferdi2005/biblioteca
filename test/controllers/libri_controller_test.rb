require 'test_helper'

class LibriControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get libri_index_url
    assert_response :success
  end

  test "should get show" do
    get libri_show_url
    assert_response :success
  end

end
