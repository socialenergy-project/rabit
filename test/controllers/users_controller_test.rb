require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    @admin = users(:one)
  end

  test "should get index as admin" do
    sign_in_as_admin
    get users_url
    assert_response :success
  end

  test "should NOT get index as user" do
    sign_in_as_user
    get users_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should NOT get index as unregistered" do

    get users_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_user_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_user_url
    assert_redirected_to root_path
  end

  test "should get new as unregistered" do
    get new_user_url
    assert_redirected_to new_user_session_path
  end

  test "should NOT create user as admin" do
    sign_in_as_admin
    assert_no_difference('User.count') do
      post users_url, params: { user: { email: @user.email } }
    end

    assert_redirected_to root_path
  end

  test "should show any user as admin" do
    current_user = sign_in_as_admin
    assert_not_equal @user, current_user, "logged in user should not be @user"
    get user_url(@user)
    assert_response :success
  end

  test "should NOT show different user as user" do
    current_user = sign_in_as_user
    assert_not_equal @admin, current_user, "logged in user should not be @admin"
    get user_url(@admin)
    assert_redirected_to root_path
  end

  test "should show current user as user" do
    current_user = sign_in_as_user
    assert_equal @user, current_user, "logged in user should be @user"
    get user_url(@user)
    assert_response :success
  end

  test "should NOT show any user as unregistered" do
    get user_url(@user)
    assert_redirected_to new_user_session_path
  end

  test "should get edit for any user as admin" do
    current_user = sign_in_as_admin
    assert_not_equal @user, current_user, "logged in user should not be @user"
    get edit_user_url(@user)
    assert_response :success
  end

  test "should NOT get edit for different user as user" do
    current_user = sign_in_as_user
    assert_not_equal @admin, current_user, "logged in user should not be @admin"
    get edit_user_url(@admin)
    assert_redirected_to root_path
  end

  test "should NOT get edit for self as user" do
    current_user = sign_in_as_user
    assert_equal @user, current_user, "logged in user should be @user"
    get edit_user_url(@user)
    assert_redirected_to root_path
  end

  test "should NOT get edit for any user as unregistered" do
    get edit_user_url(@user)
    assert_redirected_to new_user_session_path
  end

  test "should update any user as admin" do
    current_user = sign_in_as_admin
    assert_not_equal @user, current_user, "logged in user should not be @user"
    patch user_url(@user), params: { user: { email: @user.email } }
    assert_redirected_to user_url(@user)
  end

  test "should NOT update for different user as user" do
    current_user = sign_in_as_user
    assert_not_equal @admin, current_user, "logged in user should not be @admin"
    patch user_url(@admin), params: { user: { email: @admin.email } }
    assert_redirected_to root_path
  end

  test "should NOT update for self as user" do
    current_user = sign_in_as_user
    assert_equal @user, current_user, "logged in user should be @user"
    patch user_url(@user), params: { user: { email: @user.email } }
    assert_redirected_to root_path
  end

  test "should NOT update for any user as unregistered" do
    patch user_url(@user), params: { user: { email: @user.email } }
    assert_redirected_to new_user_session_path
  end

  test "should destroy any user as admin" do
    current_user = sign_in_as_admin
    assert_not_equal @user, current_user, "logged in user should not be @user"

    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

  test "should NOT destroy for different user as user" do
    current_user = sign_in_as_user
    assert_not_equal @admin, current_user, "logged in user should not be @admin"

    assert_no_difference('User.count') do
      delete user_url(@user)
    end

    assert_redirected_to root_path
  end

  test "should NOT destroy for self as user" do
    current_user = sign_in_as_user
    assert_equal @user, current_user, "logged in user should be @user"
    assert_no_difference('User.count') do
      delete user_url(@user)
    end

    assert_redirected_to root_path
  end

  test "should NOT destroy for any user as unregistered" do
    patch user_url(@user), params: { user: { email: @user.email } }
    assert_no_difference('User.count') do
      delete user_url(@user)
    end

    assert_redirected_to new_user_session_path
  end

end
