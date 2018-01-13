require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:testname)
	end	

	test "updating user with invalid information should fail" do
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), params: { user: { name: "",
																							email: "email@",
																							password: "foo",
																							password_confirmation: "bar" } }
		assert_template 'users/edit'
		assert_select "div[class=?]", "alert alert-danger", text: "The form contains 5 errors."
		@user.reload
		assert_equal @user.name, "Test Name"
		assert_equal @user.email, "test@mail.com"
		assert_equal @user, @user.authenticate("password")
	end

	test "successful update with friendly forwarding" do
		get edit_user_path(@user)
		post login_path, params: { session: { email: @user.email, password: "password" } }
		assert_redirected_to edit_user_path(@user)
		patch user_path(@user), params: { user: { name: "Michael",
																							email: "email@michael.com",
																							password: "",
																							password_confirmation: "" } }
		assert flash[:success]
		assert_redirected_to @user
		@user.reload
		assert_equal @user.name, "Michael"
		assert_equal @user.email, "email@michael.com"
		assert_equal @user, @user.authenticate("password")
		get login_path
		assert_redirected_to @user
		assert_nil session[:forwarding_url]
	end

end
