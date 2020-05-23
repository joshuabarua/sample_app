require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    get user_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as (@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }}
    assert flash.empty?
    assert_redirected_to root_url
  end                               
  
  test "should not allow the admin attribute attribute to be edited via web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: {
                                      password: "",
                                      password_confirmation: "",
                                      admin: true }
                                    }
    assert_not @other_user.reload.admin?
  end

  test " should redirect destroy when not logged in" do
    assert_no_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
