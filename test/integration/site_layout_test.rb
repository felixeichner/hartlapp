require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:testname)
	end

	test "layout links" do
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path, count: 2
		assert_select "a[href=?]", help_path, text: "Help"
		assert_select "a[href=?]", login_path, text: "Login"
		assert_select "a[href=?]", "#", text: "Account", count: 0
		assert_select "a[href=?]", user_path(@user), text: "#{@user.name}", count: 0
		assert_select "a[href=?]", edit_user_path(@user), text: "Settings", count: 0
		assert_select "a[href=?]", logout_path, text: "Logout", count: 0
		assert_select "a[href=?]", signup_path, text: "Sign Up"
		assert_select "a[href=?]", about_path, text: "About"
		assert_select "a[href=?]", contact_path, text: "Contact"

		log_in_as(@user)
		get root_path
		assert_select "a[href=?]", root_path, count: 2
		assert_select "a[href=?]", help_path, text: "Help"
		assert_select "a[href=?]", "#", text: "Account"
		assert_select "a[href=?]", user_path(@user), text: "#{@user.name}"
		assert_select "a[href=?]", edit_user_path(@user), text: "Settings"
		assert_select "a[href=?]", logout_path, text: "Logout"
		assert_select "a[href=?]", login_path, text: "Login", count: 0
		assert_select "a[href=?]", signup_path, text: "Sign Up", count: 0
		assert_select "a[href=?]", about_path, text: "About"
		assert_select "a[href=?]", contact_path, text: "Contact"

	end
end
