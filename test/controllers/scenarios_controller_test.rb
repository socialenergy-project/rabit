require 'test_helper'

class ScenariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scenario = scenarios(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get scenarios_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
    get scenarios_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as user" do
    sign_in_as_user
    get new_scenario_url
    assert_response :success
  end

  test "should NOT get new as unregistered" do
    get new_scenario_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create scenario as user" do
    user = sign_in_as_user
    assert_difference('Scenario.count') do
      post scenarios_url, params: {scenario: {ecc_type_id: @scenario.ecc_type_id, endtime: @scenario.endtime, energy_cost_parameter: @scenario.energy_cost_parameter, flexibility_id: @scenario.flexibility_id, gamma_parameter: @scenario.gamma_parameter, interval_id: @scenario.interval_id, name: @scenario.name, profit_margin_parameter: @scenario.profit_margin_parameter, starttime: @scenario.starttime, consumer_ids: @scenario.consumer_ids}}
      # puts @response.body
    end
    scenario = assigns(:scenario)
    assert_redirected_to scenario_url(scenario)
    assert_equal(user, scenario.user, "Created scenario should belong to user")
  end

  test "should NOT create scenario as unregistered" do
    assert_no_difference('Scenario.count') do
      post scenarios_url, params: {scenario: {ecc_type_id: @scenario.ecc_type_id, endtime: @scenario.endtime, energy_cost_parameter: @scenario.energy_cost_parameter, flexibility_id: @scenario.flexibility_id, gamma_parameter: @scenario.gamma_parameter, interval_id: @scenario.interval_id, name: @scenario.name, profit_margin_parameter: @scenario.profit_margin_parameter, starttime: @scenario.starttime}}
    end
    assert_redirected_to new_user_session_path
  end

  test "should show scenario as user" do
    sign_in_as_user
    get scenario_url(@scenario)
    assert_response :success
  end

  test "should NOT show scenario as unregistered" do
    get scenario_url(@scenario)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_scenario_url(@scenario)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_scenario_url(@scenario)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update scenario as admin" do
    sign_in_as_admin
    patch scenario_url(@scenario), params: {scenario: {ecc_type_id: @scenario.ecc_type_id, endtime: @scenario.endtime, energy_cost_parameter: @scenario.energy_cost_parameter, flexibility_id: @scenario.flexibility_id, gamma_parameter: @scenario.gamma_parameter, interval_id: @scenario.interval_id, name: @scenario.name, profit_margin_parameter: @scenario.profit_margin_parameter, starttime: @scenario.starttime}}
    assert_redirected_to scenario_url(@scenario)
  end

  test "should NOT update scenario as user" do
    sign_in_as_user
    patch scenario_url(@scenario), params: {scenario: {ecc_type_id: @scenario.ecc_type_id, endtime: @scenario.endtime, energy_cost_parameter: @scenario.energy_cost_parameter, flexibility_id: @scenario.flexibility_id, gamma_parameter: @scenario.gamma_parameter, interval_id: @scenario.interval_id, name: @scenario.name, profit_margin_parameter: @scenario.profit_margin_parameter, starttime: @scenario.starttime}}
    assert_redirected_to root_path
  end

  test "should update his own scenario as user" do
    sign_in_as_user(:three)
    patch scenario_url(@scenario), params: {scenario: {ecc_type_id: @scenario.ecc_type_id, endtime: @scenario.endtime, energy_cost_parameter: @scenario.energy_cost_parameter, flexibility_id: @scenario.flexibility_id, gamma_parameter: @scenario.gamma_parameter, interval_id: @scenario.interval_id, name: @scenario.name, profit_margin_parameter: @scenario.profit_margin_parameter, starttime: @scenario.starttime}}
    assert_redirected_to scenario_url(@scenario)
  end

  test "should destroy scenario as admin" do
    sign_in_as_admin
    assert_difference('Scenario.count', -1) do
      delete scenario_url(@scenario)
    end
    assert_redirected_to scenarios_url
  end

  test "should NOT destroy scenario as user" do
    sign_in_as_user
    assert_no_difference('Scenario.count') do
      delete scenario_url(@scenario)
    end
    assert_redirected_to root_path
  end

  test "should destroy his own scenario as user" do
    sign_in_as_user(:three)
    assert_difference('Scenario.count', -1) do
      delete scenario_url(@scenario)
    end
    assert_redirected_to scenarios_url
  end  

end
