require 'test_helper'

class FlexibilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @flexibility = flexibilities(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get flexibilities_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get flexibilities_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_flexibility_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_flexibility_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create flexibility as admin" do
    sign_in_as_admin
    assert_difference('Flexibility.count') do
      post flexibilities_url, params: { flexibility: { name: @flexibility.name } }
    end

    assert_redirected_to flexibility_url(Flexibility.last)
  end

  test "should NOT create flexibility as user" do
    sign_in_as_user
    assert_no_difference('Flexibility.count') do
      post flexibilities_url, params: { flexibility: { name: @flexibility.name } }
    end

    assert_redirected_to root_path
  end

  test "should show flexibility as user" do
    sign_in_as_user
    get flexibility_url(@flexibility)
    assert_response :success
  end

  test "should NOT show flexibility as unregistered" do
    get flexibility_url(@flexibility)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_flexibility_url(@flexibility)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_flexibility_url(@flexibility)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update flexibility as admin" do
    sign_in_as_admin
    patch flexibility_url(@flexibility), params: { flexibility: { name: @flexibility.name } }
    assert_redirected_to flexibility_url(@flexibility)
  end

  test "should NOT update flexibility as user" do
    sign_in_as_user
    patch flexibility_url(@flexibility), params: { flexibility: { name: @flexibility.name } }
    assert_redirected_to root_path
  end

  test "should destroy flexibility as admin" do
    sign_in_as_admin
    assert_difference('Flexibility.count', -1) do
      delete flexibility_url(@flexibility)
    end
    assert_redirected_to flexibilities_url
  end

  test "should NOT destroy flexibility as user" do
    sign_in_as_user
    assert_no_difference('Flexibility.count') do
      delete flexibility_url(@flexibility)
    end
    assert_redirected_to root_path
  end
end
