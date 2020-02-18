require 'test_helper'

class CompanysControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get companys_show_url
    assert_response :success
  end

end
