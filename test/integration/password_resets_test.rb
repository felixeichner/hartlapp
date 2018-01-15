require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:testname)
	end

	test "password resets" do
		get new_password_reset_path
		assert_template	"password_resets/new"
		
		post password_resets_path, params: { password_reset: { email: "" } }
		assert_not flash[:danger].empty?
		assert_template "password_resets/new"
		
		post password_resets_path, params: { password_reset: { email: @user.email } }
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert flash[:danger].nil?
		assert flash[:success]
		assert_redirected_to root_url

		user = assigns(:user)
		get edit_password_reset_path(user.reset_token, email: "")
		assert_not flash[:danger].empty?
		assert_redirected_to root_url

		user.toggle!(:activated)
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_not flash[:danger].empty?
		assert_redirected_to root_url
		user.toggle!(:activated)

		get edit_password_reset_path("false_token", email: user.email)
		assert_not flash[:danger].empty?
		assert_redirected_to root_url

		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_template "password_resets/edit"
		assert_select "input[name=email][type=hidden][value=?]", user.email

		patch password_reset_path(user.reset_token),
															params: { email: user.email,
																				user: { password: "foobar", 
																								password_confirmation: "barfoo" } }
		assert "div#error_explanation"

		patch password_reset_path(user.reset_token),
															params: { email: user.email,
																				user: { password: "", password_confirmation: "" } }
		assert "div#error_explanation"

		user.update_attribute(:reset_sent_at, 3.hours.ago)
		patch password_reset_path(user.reset_token),
															params: { email: user.email,
																				user: { password: "foobar",
																								password_confirmation: "foobar" } }
		assert_equal flash[:danger], "Password reset expired!"
		assert_redirected_to new_password_reset_url
		follow_redirect!
		assert_not is_logged_in?
		assert_match /expired/i, response.body
		user.update_attribute(:reset_sent_at, 1.hour.ago)
		
		patch password_reset_path(user.reset_token),
															params: { email: user.email,
																				user: { password: "foobar",
																								password_confirmation: "foobar" } }
		assert_not flash[:success].empty?
		assert is_logged_in?
		assert_redirected_to user
		assert_nil user.reload.reset_digest

	end
end
