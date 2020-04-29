require 'test_helper'

class TdsControllerTest < ActionDispatch::IntegrationTest
  test "should get daily" do
    get tds_daily_url
    assert_response :success
  end

end
