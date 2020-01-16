require 'test_helper'

class UnLocalsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get un_locals_new_url
    assert_response :success
  end

end
