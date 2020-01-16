#require 'test_helper'
require_relative '../test_helper'

class OrganismesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get organismes_new_url
    assert_response :success
  end

end
