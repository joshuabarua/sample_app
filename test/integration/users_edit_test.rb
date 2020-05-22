require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "successful edit" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_iser_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: "", 
                                              email: "foo@invalid.com",
                                              password: ""
                                              password_confirmation: "" }}

  assert_not flash.empty?
  assert_redirected_to @user
  @user.reload
  assert_equal name, @user.name
  assert_equal email, @user.email
  end
end