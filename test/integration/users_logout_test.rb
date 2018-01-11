require 'test_helper'

class UsersLogoutTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:testname)
  end

	test "logout user successfully" do
  	get login_path
		login_testuser
		assert is_logged_in?
		delete logout_path
		assert_redirected_to root_path
		follow_redirect!
		assert_not is_logged_in?
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", logout_path, count: 0
		assert_select "a[href=?]", user_path(@user), count: 0
		assert_select "a[href=?]", "#", text: "Settings", count: 0
		assert_select "a[href=?]", "#", text: "Account", count: 0
	end
end
