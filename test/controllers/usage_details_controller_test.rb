require "test_helper"

class UsageDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get usage_details_index_url
    assert_response :success
  end
end
