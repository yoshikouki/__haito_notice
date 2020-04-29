require 'test_helper'

class TdisControllerTest < ActionDispatch::IntegrationTest
  test "should get daily" do
    get tdis_daily_url
    assert_response :success
  end

end
