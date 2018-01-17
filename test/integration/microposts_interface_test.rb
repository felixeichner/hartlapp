require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:testname)
	end

	test "micropost interface" do
		log_in_as @user
		get root_path
		assert_select 'ul.pagination'
		assert_select "input[type=file]"

		assert_no_difference 'Micropost.count' do
			post microposts_path, params: { micropost: { content: "", user_id: @user.id } }
		end
		assert_select 'div#error_explanation'

		content = "This is some test content"
		picture = fixture_file_upload('test/fixtures/files/70000005.JPG', 'image/jpg')
		assert_difference 'Micropost.count', 1 do
			post microposts_path, params: { micropost: { content: content, picture: picture } }
		end
		assert_select 'div#error_explanation', count: 0
		assert_equal flash[:success], "Micropost published!"
		assert_redirected_to root_url
		follow_redirect!
		assert_match content, response.body
		assert_match '70000005', response.body

		assert_select 'a', text: "delete post"
		micropost = @user.microposts.paginate(page: 1).first
		assert_difference 'Micropost.count', -1 do
			delete micropost_path(micropost)
		end
		assert_equal flash[:success], "Micropost deleted!"
		assert_redirected_to root_url

		get user_path(users(:archer))
		assert_select 'a', text: "delete post", count: 0
	end

	test "micropost sidebar count" do
		log_in_as(@user)
		get root_url
		assert_match "#{@user.microposts.count} microposts", response.body
		other_user = users(:malory)
		log_in_as(other_user)
		get root_url
		assert_match "0 microposts", response.body
		other_user.microposts.create!(content: "Test content")
		get root_url
		assert_match "1 micropost", response.body
	end
end
