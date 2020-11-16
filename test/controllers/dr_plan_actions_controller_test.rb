require 'test_helper'

class DrPlanActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dr_plan_action = dr_plan_actions(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get dr_plan_actions_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get dr_plan_actions_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_dr_plan_action_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_dr_plan_action_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create dr_plan_action as admin" do
    sign_in_as_admin
    assert_difference('DrPlanAction.count') do
      post dr_plan_actions_url, params: { dr_plan_action: { {"consumer_id"=>"@dr_plan_action.consumer_id", "dr_target_id"=>"@dr_plan_action.dr_target_id", "price_per_mw"=>"@dr_plan_action.price_per_mw", "volume_planned"=>"@dr_plan_action.volume_planned"} } }
    end

    assert_redirected_to dr_plan_action_url(DrPlanAction.last)
  end

  test "should NOT create dr_plan_action as user" do
    sign_in_as_user
    assert_no_difference('DrPlanAction.count') do
      post dr_plan_actions_url, params: { dr_plan_action: { {"consumer_id"=>"@dr_plan_action.consumer_id", "dr_target_id"=>"@dr_plan_action.dr_target_id", "price_per_mw"=>"@dr_plan_action.price_per_mw", "volume_planned"=>"@dr_plan_action.volume_planned"} } }
    end

    assert_redirected_to root_path
  end

  test "should show dr_plan_action as user" do
    sign_in_as_user
    get dr_plan_action_url(@dr_plan_action)
    assert_response :success
  end

  test "should NOT show dr_plan_action as unregistered" do
    get dr_plan_action_url(@dr_plan_action)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_dr_plan_action_url(@dr_plan_action)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_dr_plan_action_url(@dr_plan_action)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update dr_plan_action as admin" do
    sign_in_as_admin
    patch dr_plan_action_url(@dr_plan_action), params: { dr_plan_action: { {"consumer_id"=>"@dr_plan_action.consumer_id", "dr_target_id"=>"@dr_plan_action.dr_target_id", "price_per_mw"=>"@dr_plan_action.price_per_mw", "volume_planned"=>"@dr_plan_action.volume_planned"} } }
    assert_redirected_to dr_plan_action_url(@dr_plan_action)
  end

  test "should NOT update dr_plan_action as user" do
    sign_in_as_user
    patch dr_plan_action_url(@dr_plan_action), params: { dr_plan_action: { {"consumer_id"=>"@dr_plan_action.consumer_id", "dr_target_id"=>"@dr_plan_action.dr_target_id", "price_per_mw"=>"@dr_plan_action.price_per_mw", "volume_planned"=>"@dr_plan_action.volume_planned"} } }
    assert_redirected_to root_path
  end

  test "should destroy dr_plan_action as admin" do
    sign_in_as_admin
    assert_difference('DrPlanAction.count', -1) do
      delete dr_plan_action_url(@dr_plan_action)
    end
    assert_redirected_to dr_plan_actions_url
  end

  test "should NOT destroy dr_plan_action as user" do
    sign_in_as_user
    assert_no_difference('DrPlanAction.count') do
      delete dr_plan_action_url(@dr_plan_action)
    end
    assert_redirected_to root_path
  end
end
