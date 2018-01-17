require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

	def setup
		@user = users(:testname)
	end

	test "profile display" do
		log_in_as @user
		get user_path(@user)
		assert_template "users/show"
		assert_select "title", full_title("User Profile: #{@user.name}")
		assert_select 'h3', text: @user.name
		assert_select 'div>img.gravatar'
		assert_match @user.microposts.count.to_s, response.body
		assert_select 'ul.pagination', count: 1
		@user.microposts.paginate(page: 1, per_page: 7).each do |micropost|
			assert_match micropost.content, response.body
		end
	end
end
