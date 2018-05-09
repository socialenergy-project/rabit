require 'test_helper'

class ConnectionTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @connection_type = connection_types(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get connection_types_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get connection_types_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_connection_type_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_connection_type_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create connection_type as admin" do
    sign_in_as_admin
    assert_difference('ConnectionType.count') do
      post connection_types_url, params: { connection_type: { name: @connection_type.name } }
    end

    assert_redirected_to connection_type_url(ConnectionType.last)
  end

  test "should NOT create connection_type as user" do
    sign_in_as_user
    assert_no_difference('ConnectionType.count') do
      post connection_types_url, params: { connection_type: { name: @connection_type.name } }
    end

    assert_redirected_to root_path
  end

  test "should show connection_type as user" do
    sign_in_as_user
    get connection_type_url(@connection_type)
    assert_response :success
  end

  test "should NOT show connection_type as unregistered" do
    get connection_type_url(@connection_type)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_connection_type_url(@connection_type)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_connection_type_url(@connection_type)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update connection_type as admin" do
    sign_in_as_admin
    patch connection_type_url(@connection_type), params: { connection_type: { name: @connection_type.name } }
    assert_redirected_to connection_type_url(@connection_type)
  end

  test "should NOT update connection_type as user" do
    sign_in_as_user
    patch connection_type_url(@connection_type), params: { connection_type: { name: @connection_type.name } }
    assert_redirected_to root_path
  end

  test "should destroy connection_type as admin if empty" do
    sign_in_as_admin
    @connection_type.consumers.each{ |c| c.connection_type = nil; c.save }
    assert_difference('ConnectionType.count', -1) do
      delete connection_type_url(@connection_type)
    end
    assert_redirected_to connection_types_url
  end

  test "should NOT destroy connection_type as admin if NOT empty" do
    sign_in_as_admin
    assert_no_difference('ConnectionType.count') do
      delete connection_type_url(@connection_type)
    end
    assert_redirected_to connection_types_url
  end

  test "should NOT destroy connection_type as user" do
    sign_in_as_user
    assert_no_difference('ConnectionType.count') do
      delete connection_type_url(@connection_type)
    end
    assert_redirected_to root_path
  end
end
