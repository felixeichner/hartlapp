require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:testname)
  end

  test "login with invalid information" do
  	get login_path
  	assert_template 'sessions/new'
  	post login_path, params: { session: { email: @user.email, password: "1234" } }
  	assert_template 'sessions/new'
  	assert flash[:danger]
  	get root_path
  	assert flash.empty?
  end

  test "login with valid information" do
  	get login_path
  	assert_template 'sessions/new'
  	post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", "#", text: "Account"
    assert_select "a[href=?]", user_path(@user), text: @user.name
    assert_select "a[href=?]", "#", text: "Settings"
    assert_select "a[href=?]", logout_path, method: :delete, text: "Logout"
  	assert flash[:success]
  	get root_path
  	assert flash.empty?
  end

  test "user already logged in" do
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    get login_path
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert flash[:success] == "You are already logged in!"
  end
end
