require 'test_helper'

class BuildingTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @building_type = building_types(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get building_types_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get building_types_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_building_type_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_building_type_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create building_type as admin" do
    sign_in_as_admin
    assert_difference('BuildingType.count') do
      post building_types_url, params: { building_type: { name: @building_type.name } }
    end

    assert_redirected_to building_type_url(BuildingType.last)
  end

  test "should NOT create building_type as user" do
    sign_in_as_user
    assert_no_difference('BuildingType.count') do
      post building_types_url, params: { building_type: { name: @building_type.name } }
    end

    assert_redirected_to root_path
  end

  test "should show building_type as user" do
    sign_in_as_user
    get building_type_url(@building_type)
    assert_response :success
  end

  test "should NOT show building_type as unregistered" do
    get building_type_url(@building_type)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_building_type_url(@building_type)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_building_type_url(@building_type)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update building_type as admin" do
    sign_in_as_admin
    patch building_type_url(@building_type), params: { building_type: { name: @building_type.name } }
    assert_redirected_to building_type_url(@building_type)
  end

  test "should NOT update building_type as user" do
    sign_in_as_user
    patch building_type_url(@building_type), params: { building_type: { name: @building_type.name } }
    assert_redirected_to root_path
  end

  test "should destroy building_type as admin if empty" do
    sign_in_as_admin
    @building_type.consumers.each {|c| c.building_type = nil; c.save }
    assert_difference('BuildingType.count', -1) do
      delete building_type_url(@building_type)
    end
    assert_redirected_to building_types_url
  end

  test "should NOT destroy building_type as admin if NOT empty" do
    sign_in_as_admin
    assert_no_difference('BuildingType.count') do
      delete building_type_url(@building_type)
    end
    assert_redirected_to building_types_url
  end

  test "should NOT destroy building_type as user" do
    sign_in_as_user
    assert_no_difference('BuildingType.count') do
      delete building_type_url(@building_type)
    end
    assert_redirected_to root_path
  end
end
