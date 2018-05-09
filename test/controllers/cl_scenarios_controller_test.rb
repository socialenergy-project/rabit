require 'test_helper'

class ClScenariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cl_scenario = cl_scenarios(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get cl_scenarios_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get cl_scenarios_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_cl_scenario_url
    assert_response :success
  end

  test "should NOT get new as unregistered" do
    get new_cl_scenario_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create cl_scenario as user" do
    user = sign_in_as_user
    assert_difference('ClScenario.count') do
      post cl_scenarios_url, params: { cl_scenario: { algorithm: @cl_scenario.algorithm, clustering_id: @cl_scenario.clustering_id, endtime: @cl_scenario.endtime, interval_id: @cl_scenario.interval_id, kappa: @cl_scenario.kappa, name: @cl_scenario.name, starttime: @cl_scenario.starttime, consumer_ids: @cl_scenario.consumer_ids, flexibility_id: @cl_scenario.flexibility_id  } }
      # puts @response.parsed_body
    end
    cl_scenario = assigns(:cl_scenario)
    assert_redirected_to cl_scenario_url(cl_scenario)
    assert_equal(user, cl_scenario.user, "Created cl_scenario should belong to user")
  end

  test "should NOT create cl_scenario as unregistered" do
    assert_no_difference('ClScenario.count') do
      post cl_scenarios_url, params: { cl_scenario: { algorithm: @cl_scenario.algorithm, clustering_id: @cl_scenario.clustering_id, endtime: @cl_scenario.endtime, interval_id: @cl_scenario.interval_id, kappa: @cl_scenario.kappa, name: @cl_scenario.name, starttime: @cl_scenario.starttime , flexibility_id: @cl_scenario.flexibility_id } }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show cl_scenario as user" do
    sign_in_as_user
    get cl_scenario_url(@cl_scenario)
    assert_response :success
  end

  test "should NOT show cl_scenario as unregistered" do
    get cl_scenario_url(@cl_scenario)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_cl_scenario_url(@cl_scenario)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_cl_scenario_url(@cl_scenario)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update cl_scenario as admin" do
    sign_in_as_admin
    patch cl_scenario_url(@cl_scenario), params: { cl_scenario: { algorithm: @cl_scenario.algorithm, clustering_id: @cl_scenario.clustering_id, endtime: @cl_scenario.endtime, interval_id: @cl_scenario.interval_id, kappa: @cl_scenario.kappa, name: @cl_scenario.name, starttime: @cl_scenario.starttime, flexibility_id: @cl_scenario.flexibility_id } }
    assert_redirected_to cl_scenario_url(@cl_scenario)
  end

  test "should NOT update cl_scenario as user" do
    sign_in_as_user
    patch cl_scenario_url(@cl_scenario), params: { cl_scenario: { algorithm: @cl_scenario.algorithm, clustering_id: @cl_scenario.clustering_id, endtime: @cl_scenario.endtime, interval_id: @cl_scenario.interval_id, kappa: @cl_scenario.kappa, name: @cl_scenario.name, starttime: @cl_scenario.starttime, flexibility_id: @cl_scenario.flexibility_id } }
    assert_redirected_to root_path
  end

  test "should update his own cl_scenario as user" do
    sign_in_as_user(:three)
    patch cl_scenario_url(@cl_scenario), params: { cl_scenario: { algorithm: @cl_scenario.algorithm, clustering_id: @cl_scenario.clustering_id, endtime: @cl_scenario.endtime, interval_id: @cl_scenario.interval_id, kappa: @cl_scenario.kappa, name: @cl_scenario.name, starttime: @cl_scenario.starttime, flexibility_id: @cl_scenario.flexibility_id } }
    # puts @response.body
    assert_redirected_to cl_scenario_url(@cl_scenario)
  end

  test "should destroy cl_scenario as admin" do
    sign_in_as_admin
    assert_difference('ClScenario.count', -1) do
      delete cl_scenario_url(@cl_scenario)
    end
    assert_redirected_to cl_scenarios_url
  end

  test "should NOT destroy cl_scenario as user" do
    sign_in_as_user
    assert_no_difference('ClScenario.count') do
      delete cl_scenario_url(@cl_scenario)
    end
    assert_redirected_to root_path
  end

  test "should destroy his own cl_scenario as user" do
    sign_in_as_user(:three)
    assert_difference('ClScenario.count', -1) do
      delete cl_scenario_url(@cl_scenario)
    end
    assert_redirected_to cl_scenarios_url
  end
end
