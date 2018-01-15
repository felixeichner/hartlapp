require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
	def setup
		@admin = users(:testname)
		@non_admin = users(:archer)
	end

	test "index as admin including pagination and delete links" do
		log_in_as(@admin)
		get users_path
		assert_template "users/index"
		assert_select "ul[class=?]", "pagination", count: 2
		User.paginate(page: 1, per_page: 15).each do |user|
			if user.activated?
				assert_select "a[href=?]", user_path(user), text: user.name
				assert_select "a[href=?]", user_path(user), text: "Delete User"
			else
				assert_select "a[href=?]", user_path(user), text: user.name, count: 0
				assert_select "a[href=?]", user_path(user), text: "Delete User", count: 0	
			end
		end
	end

	test "index as non-admin without delete links other than own" do
		log_in_as(@non_admin)
		get users_path
		assert_template "users/index"
		assert_select "ul[class=?]", "pagination", count: 2
		User.paginate(page: 1, per_page: 15).each do |user|
			if user.activated?
			 	assert_select "a[href=?]", user_path(user), text: user.name
				assert_select "a[href=?]", user_path(user),
											text: "Delete User", count: 1 if @non_admin == user
				assert_select "a[href=?]", user_path(user),
											text: "Delete User", count: 0 if @non_admin != user
			else
			 	assert_select "a[href=?]", user_path(user), text: user.name, count: 0
				assert_select "a[href=?]", user_path(user), text: "Delete User", count: 0
			end
		end
	end	


end
