require 'test_helper'

class FixedCampaignControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fixed_campaign_index_url
    assert_response :success
  end

end
