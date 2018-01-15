require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account activation" do
    user = users(:testname)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation link", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi #{user.name}", mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
  end

  test "reset password" do
    user = users(:testname)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset link", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi #{user.name}", mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
    assert_match user.reset_token, mail.body.encoded
  end
end
