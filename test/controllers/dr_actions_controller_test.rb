require 'test_helper'

class DrActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dr_action = dr_actions(:one)
  end

  test 'should get index as user' do
    sign_in_as_user
    get dr_actions_url
    assert_response :success
  end

  test 'should NOT get index as unregistered' do
    get dr_actions_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get new as admin' do
    sign_in_as_admin
    get new_dr_action_url
    assert_response :success
  end

  test 'should NOT get new as user' do
    sign_in_as_user
    get new_dr_action_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should create dr_action as admin' do
    sign_in_as_admin
    assert_difference('DrAction.count') do
      post dr_actions_url, params: { dr_action: { 'consumer_id' => consumers(:three).id, 'dr_target_id' => dr_targets(:two).id, 'price_per_mw' => '@dr_action.price_per_mw', 'volume_actual' => '@dr_action.volume_actual', 'volume_planned' => '@dr_action.volume_planned' } }
      assert_select 'div#error_explanation', false, 'There should be no errors'
    end

    assert_redirected_to dr_action_url(DrAction.last)
  end

  test 'should NOT create dr_action as user' do
    sign_in_as_user
    assert_no_difference('DrAction.count') do
      post dr_actions_url, params: { dr_action: { 'consumer_id' => consumers(:three).id, 'dr_target_id' => dr_targets(:two).id, 'price_per_mw' => '@dr_action.price_per_mw', 'volume_actual' => '@dr_action.volume_actual', 'volume_planned' => '@dr_action.volume_planned' } }
    end

    assert_redirected_to root_path
  end

  test 'should show dr_action as user' do
    sign_in_as_user
    get dr_action_url(@dr_action)
    assert_response :success
  end

  test 'should NOT show dr_action as unregistered' do
    get dr_action_url(@dr_action)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get edit as admin' do
    sign_in_as_admin
    get edit_dr_action_url(@dr_action)
    assert_response :success
  end

  test 'should NOT get edit as user' do
    sign_in_as_user
    get edit_dr_action_url(@dr_action)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should update dr_action as admin' do
    sign_in_as_admin
    patch dr_action_url(@dr_action), params: { dr_action: { 'consumer_id' => consumers(:three).id, 'dr_target_id' => dr_targets(:two).id, 'price_per_mw' => '@dr_action.price_per_mw', 'volume_actual' => '@dr_action.volume_actual', 'volume_planned' => '@dr_action.volume_planned' } }
    assert_redirected_to dr_action_url(@dr_action)
  end

  test 'should NOT update dr_action as user' do
    sign_in_as_user
    patch dr_action_url(@dr_action), params: { dr_action: { 'consumer_id' => consumers(:three).id, 'dr_target_id' => dr_targets(:two).id, 'price_per_mw' => '@dr_action.price_per_mw', 'volume_actual' => '@dr_action.volume_actual', 'volume_planned' => '@dr_action.volume_planned' } }
    assert_redirected_to root_path
  end

  test 'should destroy dr_action as admin' do
    sign_in_as_admin
    assert_difference('DrAction.count', -1) do
      delete dr_action_url(@dr_action)
    end
    assert_redirected_to dr_actions_url
  end

  test 'should NOT destroy dr_action as user' do
    sign_in_as_user
    assert_no_difference('DrAction.count') do
      delete dr_action_url(@dr_action)
    end
    assert_redirected_to root_path
  end
end
