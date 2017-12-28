require 'test_helper'

class SingleMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get single_messages_create_url
    assert_response :success
  end

end
