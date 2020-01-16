#require 'test_helper'
require_relative '../test_helper'

class OrganismeReferentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get organisme_referents_new_url
    assert_response :success
  end

end
