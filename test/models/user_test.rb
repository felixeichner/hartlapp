require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "Example User", email: "user@example.com",
										 password: "123456", password_confirmation: "123456")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = "   "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "   "
		assert_not @user.valid?
	end

	test "name should be 3 to 50 characters" do
		@user.name = "F"
		assert_not @user.valid?
		@user.name = "F" * 51
		assert_not @user.valid?
	end

	test "email should be less than 256 characters" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email validation should accept valid email addresses" do
		valid_addresses = %w[any@more.com USER@any.ORG right_now-stiLL@time.jp 
												 first.second@foo.bar first+second@third.fourth]
		valid_addresses.each do |address|
			@user.email = address
			assert @user.valid?, "#{address.inspect} should be a valid email address"
		end
	end

	test "email validation should reject invalid email addresses" do
		invalid_addresses = %w[any_more.com USER@any,ORG right_now-stiLL@time first.second@foo. 
													 first@second_third.fourth first@second+third.fourth foo@bar..baz]
		invalid_addresses.each do |address|
			@user.email = address
			assert_not @user.valid?, "#{address.inspect} should be an invalid email address"
		end
	end

	test "email should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email.upcase!
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email should be downcased" do
		@user.email = "FoO@BAr.bAz"
		downcase_email = @user.email.downcase
		@user.save
		assert_equal downcase_email, @user.reload.email
	end

	test "password should be present (nonblank)" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "password should have at least 6 characters" do
		@user.password = @user.password_confirmation = "p" * 5
		assert_not @user.valid?
	end

	test "password and password_confirmation should be identical" do
		@user.password = "123456"
		@user.password_confirmation = "654321"
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with remember_digest nil value" do
		assert_not @user.authenticated?("")
	end
end
