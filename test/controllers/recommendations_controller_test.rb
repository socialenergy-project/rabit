require 'test_helper'

class RecommendationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recommendation = recommendations(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get recommendations_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get recommendations_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_recommendation_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_recommendation_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create recommendation as admin" do
    sign_in_as_admin
    assert_difference('Recommendation.count') do
      post recommendations_url, params: { recommendation: { parameter: @recommendation.parameter, recommendation_type_id: @recommendation.recommendation_type_id, scenario_id: @recommendation.scenario_id, status: @recommendation.status } }
    end

    assert_redirected_to recommendation_url(Recommendation.last)
  end

  test "should NOT create recommendation as user" do
    sign_in_as_user
    assert_no_difference('Recommendation.count') do
      post recommendations_url, params: { recommendation: { parameter: @recommendation.parameter, recommendation_type_id: @recommendation.recommendation_type_id, scenario_id: @recommendation.scenario_id, status: @recommendation.status } }
    end

    assert_redirected_to root_path
  end

  test "should show recommendation as user" do
    sign_in_as_user
    get recommendation_url(@recommendation)
    assert_response :success
  end

  test "should NOT show recommendation as unregistered" do
    get recommendation_url(@recommendation)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_recommendation_url(@recommendation)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_recommendation_url(@recommendation)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update recommendation as admin" do
    sign_in_as_admin
    patch recommendation_url(@recommendation), params: { recommendation: { parameter: @recommendation.parameter, recommendation_type_id: @recommendation.recommendation_type_id, scenario_id: @recommendation.scenario_id, status: @recommendation.status } }
    assert_redirected_to recommendation_url(@recommendation)
  end

  test "should NOT update recommendation as user" do
    sign_in_as_user
    patch recommendation_url(@recommendation), params: { recommendation: { parameter: @recommendation.parameter, recommendation_type_id: @recommendation.recommendation_type_id, scenario_id: @recommendation.scenario_id, status: @recommendation.status } }
    assert_redirected_to root_path
  end

  test "should destroy recommendation as admin" do
    sign_in_as_admin
    assert_difference('Recommendation.count', -1) do
      delete recommendation_url(@recommendation)
    end
    assert_redirected_to recommendations_url
  end

  test "should NOT destroy recommendation as user" do
    sign_in_as_user
    assert_no_difference('Recommendation.count') do
      delete recommendation_url(@recommendation)
    end
    assert_redirected_to root_path
  end
end
