require 'test_helper'

class RecommendationTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recommendation_type = recommendation_types(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get recommendation_types_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get recommendation_types_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_recommendation_type_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_recommendation_type_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create recommendation_type as admin" do
    sign_in_as_admin
    assert_difference('RecommendationType.count') do
      post recommendation_types_url, params: { recommendation_type: { description: @recommendation_type.description, name: @recommendation_type.name } }
    end

    assert_redirected_to recommendation_type_url(RecommendationType.last)
  end

  test "should NOT create recommendation_type as user" do
    sign_in_as_user
    assert_no_difference('RecommendationType.count') do
      post recommendation_types_url, params: { recommendation_type: { description: @recommendation_type.description, name: @recommendation_type.name } }
    end

    assert_redirected_to root_path
  end

  test "should show recommendation_type as user" do
    sign_in_as_user
    get recommendation_type_url(@recommendation_type)
    assert_response :success
  end

  test "should NOT show recommendation_type as unregistered" do
    get recommendation_type_url(@recommendation_type)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_recommendation_type_url(@recommendation_type)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_recommendation_type_url(@recommendation_type)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update recommendation_type as admin" do
    sign_in_as_admin
    patch recommendation_type_url(@recommendation_type), params: { recommendation_type: { description: @recommendation_type.description, name: @recommendation_type.name } }
    assert_redirected_to recommendation_type_url(@recommendation_type)
  end

  test "should NOT update recommendation_type as user" do
    sign_in_as_user
    patch recommendation_type_url(@recommendation_type), params: { recommendation_type: { description: @recommendation_type.description, name: @recommendation_type.name } }
    assert_redirected_to root_path
  end

  test "should destroy recommendation_type as admin" do
    sign_in_as_admin
    assert_difference('RecommendationType.count', -1) do
      delete recommendation_type_url(@recommendation_type)
    end
    assert_redirected_to recommendation_types_url
  end

  test "should NOT destroy recommendation_type as user" do
    sign_in_as_user
    assert_no_difference('RecommendationType.count') do
      delete recommendation_type_url(@recommendation_type)
    end
    assert_redirected_to root_path
  end
end
