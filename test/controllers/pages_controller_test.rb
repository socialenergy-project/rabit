require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home when logged in" do

    sign_in_as_admin

    get root_path
    assert_response :success
  end

  test "should redirect to login page when NOT logged in" do

    get root_path
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

end
