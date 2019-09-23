require 'test_helper'

class SmartPlugsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @smart_plug = smart_plugs(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get smart_plugs_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get smart_plugs_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_smart_plug_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_smart_plug_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create smart_plug as admin" do
    sign_in_as_admin
    assert_difference('SmartPlug.count') do
      post smart_plugs_url, params: { smart_plug: {"consumer_id"=>@smart_plug.consumer_id, "mqtt_name"=>@smart_plug.mqtt_name, "name"=>@smart_plug.name} }
    end

    assert_redirected_to smart_plug_url(SmartPlug.last)
  end

  test "should NOT create smart_plug as user" do
    sign_in_as_user
    assert_no_difference('SmartPlug.count') do
      post smart_plugs_url, params: { smart_plug: {"consumer_id"=>@smart_plug.consumer_id, "mqtt_name"=>@smart_plug.mqtt_name, "name"=>@smart_plug.name} }
    end

    assert_redirected_to root_path
  end

  test "should show smart_plug as user" do
    sign_in_as_user
    get smart_plug_url(@smart_plug)
    assert_response :success
  end

  test "should NOT show smart_plug as unregistered" do
    get smart_plug_url(@smart_plug)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_smart_plug_url(@smart_plug)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_smart_plug_url(@smart_plug)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update smart_plug as admin" do
    sign_in_as_admin
    patch smart_plug_url(@smart_plug), params: { smart_plug: {"consumer_id"=>@smart_plug.consumer_id, "mqtt_name"=>@smart_plug.mqtt_name, "name"=>@smart_plug.name} }
    assert_redirected_to smart_plug_url(@smart_plug)
  end

  test "should NOT update smart_plug as user" do
    sign_in_as_user
    patch smart_plug_url(@smart_plug), params: { smart_plug: {"consumer_id"=>@smart_plug.consumer_id, "mqtt_name"=>@smart_plug.mqtt_name, "name"=>@smart_plug.name} }
    assert_redirected_to root_path
  end

  test "should destroy smart_plug as admin" do
    sign_in_as_admin
    assert_difference('SmartPlug.count', -1) do
      delete smart_plug_url(@smart_plug)
    end
    assert_redirected_to smart_plugs_url
  end

  test "should NOT destroy smart_plug as user" do
    sign_in_as_user
    assert_no_difference('SmartPlug.count') do
      delete smart_plug_url(@smart_plug)
    end
    assert_redirected_to root_path
  end
end
