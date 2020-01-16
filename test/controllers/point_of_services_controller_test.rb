#require 'test_helper'
require_relative '../test_helper'

class PointOfServicesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get point_of_services_new_url
    assert_response :success
  end

end
