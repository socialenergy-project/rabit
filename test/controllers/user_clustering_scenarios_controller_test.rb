require 'test_helper'

class UserClusteringScenariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_clustering_scenario = user_clustering_scenarios(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get user_clustering_scenarios_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get user_clustering_scenarios_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_user_clustering_scenario_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_user_clustering_scenario_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create user_clustering_scenario as admin" do
    sign_in_as_admin
    assert_difference('UserClusteringScenario.count') do
      post user_clustering_scenarios_url, params: { user_clustering_scenario: { kappa: @user_clustering_scenario.kappa, name: @user_clustering_scenario.name, parameters: [ :game_score, :game_activity ]  } }
    end

    assert_redirected_to user_clustering_scenario_url(UserClusteringScenario.last)
  end

  test "should NOT create user_clustering_scenario as user" do
    sign_in_as_user
    assert_no_difference('UserClusteringScenario.count') do
      post user_clustering_scenarios_url, params: { user_clustering_scenario: { kappa: @user_clustering_scenario.kappa, silhouette: @user_clustering_scenario.silhouette } }
    end

    assert_redirected_to root_path
  end

  test "should show user_clustering_scenario as user" do
    sign_in_as_user
    get user_clustering_scenario_url(@user_clustering_scenario)
    assert_response :success
  end

  test "should NOT show user_clustering_scenario as unregistered" do
    get user_clustering_scenario_url(@user_clustering_scenario)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_user_clustering_scenario_url(@user_clustering_scenario)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_user_clustering_scenario_url(@user_clustering_scenario)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update user_clustering_scenario as admin" do
    sign_in_as_admin
    patch user_clustering_scenario_url(@user_clustering_scenario), params: { user_clustering_scenario: { kappa: @user_clustering_scenario.kappa, silhouette: @user_clustering_scenario.silhouette } }
    assert_redirected_to user_clustering_scenario_url(@user_clustering_scenario)
  end

  test "should NOT update user_clustering_scenario as user" do
    sign_in_as_user
    patch user_clustering_scenario_url(@user_clustering_scenario), params: { user_clustering_scenario: { kappa: @user_clustering_scenario.kappa, silhouette: @user_clustering_scenario.silhouette } }
    assert_redirected_to root_path
  end

  test "should destroy user_clustering_scenario as admin" do
    sign_in_as_admin
    assert_difference('UserClusteringScenario.count', -1) do
      delete user_clustering_scenario_url(@user_clustering_scenario)
    end
    assert_redirected_to user_clustering_scenarios_url
  end

  test "should NOT destroy user_clustering_scenario as user" do
    sign_in_as_user
    assert_no_difference('UserClusteringScenario.count') do
      delete user_clustering_scenario_url(@user_clustering_scenario)
    end
    assert_redirected_to root_path
  end
end
