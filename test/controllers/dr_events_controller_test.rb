require 'test_helper'

class DrEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dr_event = dr_events(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get dr_events_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get dr_events_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_dr_event_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_dr_event_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create dr_event as admin" do
    sign_in_as_admin
    assert_difference('DrEvent.count') do
      post dr_events_url, params: { dr_event: { {"interval_id"=>"@dr_event.interval_id", "name"=>"@dr_event.name", "price"=>"@dr_event.price", "starttime"=>"@dr_event.starttime", "state"=>"@dr_event.state", "type"=>"@dr_event.type"} } }
    end

    assert_redirected_to dr_event_url(DrEvent.last)
  end

  test "should NOT create dr_event as user" do
    sign_in_as_user
    assert_no_difference('DrEvent.count') do
      post dr_events_url, params: { dr_event: { {"interval_id"=>"@dr_event.interval_id", "name"=>"@dr_event.name", "price"=>"@dr_event.price", "starttime"=>"@dr_event.starttime", "state"=>"@dr_event.state", "type"=>"@dr_event.type"} } }
    end

    assert_redirected_to root_path
  end

  test "should show dr_event as user" do
    sign_in_as_user
    get dr_event_url(@dr_event)
    assert_response :success
  end

  test "should NOT show dr_event as unregistered" do
    get dr_event_url(@dr_event)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_dr_event_url(@dr_event)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_dr_event_url(@dr_event)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update dr_event as admin" do
    sign_in_as_admin
    patch dr_event_url(@dr_event), params: { dr_event: { {"interval_id"=>"@dr_event.interval_id", "name"=>"@dr_event.name", "price"=>"@dr_event.price", "starttime"=>"@dr_event.starttime", "state"=>"@dr_event.state", "type"=>"@dr_event.type"} } }
    assert_redirected_to dr_event_url(@dr_event)
  end

  test "should NOT update dr_event as user" do
    sign_in_as_user
    patch dr_event_url(@dr_event), params: { dr_event: { {"interval_id"=>"@dr_event.interval_id", "name"=>"@dr_event.name", "price"=>"@dr_event.price", "starttime"=>"@dr_event.starttime", "state"=>"@dr_event.state", "type"=>"@dr_event.type"} } }
    assert_redirected_to root_path
  end

  test "should destroy dr_event as admin" do
    sign_in_as_admin
    assert_difference('DrEvent.count', -1) do
      delete dr_event_url(@dr_event)
    end
    assert_redirected_to dr_events_url
  end

  test "should NOT destroy dr_event as user" do
    sign_in_as_user
    assert_no_difference('DrEvent.count') do
      delete dr_event_url(@dr_event)
    end
    assert_redirected_to root_path
  end
end
