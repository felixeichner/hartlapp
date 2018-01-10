require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
  	@user = User.create(name: "Example", email: "test@example.com", password: "111111")
  end

  test "should get show of certain user" do
  	get user_path(@user)
  	assert_response :success
  	assert_select "title", full_title("User Profile: Example")
  end
end
