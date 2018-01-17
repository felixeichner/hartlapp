require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:testname)
  	@other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
  end

  test "should get show of certain user" do
  	get user_path(@user)
  	assert_response :success
  	assert_select "title", full_title("User Profile: Test Name")
  end

  test "should redirect edit when not logged in" do
  	get edit_user_path(@user)
  	assert_equal flash[:danger], "You need to be logged in!"
  	assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
  	patch user_path(@user), params: { user: { name: "Michael", email: "email@michael.com" } }
  	assert_redirected_to login_path
  	assert_equal flash[:danger], "You need to be logged in!"
		@user.reload
  	assert_equal @user.name, "Test Name"
  	assert_equal @user.email, "test@mail.com"
  end

  test "should redirect edit when logged in as other user" do
  	log_in_as(@other_user)
  	get edit_user_path(@user)
  	assert_redirected_to root_url
  end

  test "should redirect update when logged in as other user" do
  	log_in_as(@other_user)
  	patch user_path(@user), params: { name: "Anna", email: "anna@testmail.com" }
  	assert_redirected_to root_url
  	@user.reload
  	assert_equal @user.name, "Test Name"
  	assert_equal @user.email, "test@mail.com"
  end

  test "admin attribute cannot be changed through web requests" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect delete and fail deleting when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_equal flash[:danger], "You need to be logged in!"
    assert_redirected_to login_url
  end

  test "should redirect delete and fail deleting when different non-admin user" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_equal flash[:danger], "You can only delete your own profile!"
    assert_redirected_to @other_user
  end

  test "should redirect delete and succeed deleting when admin user" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_equal flash[:success], "Profile successfully deleted!"
    assert_redirected_to users_path
  end
end
