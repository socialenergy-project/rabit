require 'test_helper'

class DrTargetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dr_target = dr_targets(:one)
  end

  test "should get index as user" do
    sign_in_as_admin
    get dr_targets_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get dr_targets_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_dr_target_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_dr_target_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create dr_target as admin" do
    sign_in_as_admin
    assert_difference('DrTarget.count') do
      post dr_targets_url, params: { dr_target: { {"cleared_price"=>"@dr_target.cleared_price", "dr_event_id"=>"@dr_target.dr_event_id", "ts_offset"=>"@dr_target.ts_offset", "volume"=>"@dr_target.volume"} } }
    end

    assert_redirected_to dr_target_url(DrTarget.last)
  end

  test "should NOT create dr_target as user" do
    sign_in_as_user
    assert_no_difference('DrTarget.count') do
      post dr_targets_url, params: { dr_target: { {"cleared_price"=>"@dr_target.cleared_price", "dr_event_id"=>"@dr_target.dr_event_id", "ts_offset"=>"@dr_target.ts_offset", "volume"=>"@dr_target.volume"} } }
    end

    assert_redirected_to root_path
  end

  test "should show dr_target as user" do
    sign_in_as_user
    get dr_target_url(@dr_target)
    assert_response :success
  end

  test "should NOT show dr_target as unregistered" do
    get dr_target_url(@dr_target)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_dr_target_url(@dr_target)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_dr_target_url(@dr_target)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update dr_target as admin" do
    sign_in_as_admin
    patch dr_target_url(@dr_target), params: { dr_target: { {"cleared_price"=>"@dr_target.cleared_price", "dr_event_id"=>"@dr_target.dr_event_id", "ts_offset"=>"@dr_target.ts_offset", "volume"=>"@dr_target.volume"} } }
    assert_redirected_to dr_target_url(@dr_target)
  end

  test "should NOT update dr_target as user" do
    sign_in_as_user
    patch dr_target_url(@dr_target), params: { dr_target: { {"cleared_price"=>"@dr_target.cleared_price", "dr_event_id"=>"@dr_target.dr_event_id", "ts_offset"=>"@dr_target.ts_offset", "volume"=>"@dr_target.volume"} } }
    assert_redirected_to root_path
  end

  test "should destroy dr_target as admin" do
    sign_in_as_admin
    assert_difference('DrTarget.count', -1) do
      delete dr_target_url(@dr_target)
    end
    assert_redirected_to dr_targets_url
  end

  test "should NOT destroy dr_target as user" do
    sign_in_as_user
    assert_no_difference('DrTarget.count') do
      delete dr_target_url(@dr_target)
    end
    assert_redirected_to root_path
  end
end
