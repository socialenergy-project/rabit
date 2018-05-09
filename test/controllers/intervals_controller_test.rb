require 'test_helper'

class IntervalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interval = intervals(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get intervals_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get intervals_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_interval_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_interval_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create interval as admin" do
    sign_in_as_admin
    assert_difference('Interval.count') do
      post intervals_url, params: { interval: { duration: @interval.duration, name: @interval.name } }
    end

    assert_redirected_to interval_url(Interval.last)
  end

  test "should NOT create interval as user" do
    sign_in_as_user
    assert_no_difference('Interval.count') do
      post intervals_url, params: { interval: { duration: @interval.duration, name: @interval.name } }
    end

    assert_redirected_to root_path
  end

  test "should show interval as user" do
    sign_in_as_user
    get interval_url(@interval)
    assert_response :success
  end

  test "should NOT show interval as unregistered" do
    get interval_url(@interval)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_interval_url(@interval)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_interval_url(@interval)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update interval as admin" do
    sign_in_as_admin
    patch interval_url(@interval), params: { interval: { duration: @interval.duration, name: @interval.name } }
    assert_redirected_to interval_url(@interval)
  end

  test "should NOT update interval as user" do
    sign_in_as_user
    patch interval_url(@interval), params: { interval: { duration: @interval.duration, name: @interval.name } }
    assert_redirected_to root_path
  end

  test "should destroy interval as admin" do
    sign_in_as_admin
    assert_difference('Interval.count', -1) do
      delete interval_url(@interval)
    end
    assert_redirected_to intervals_url
  end

  test "should NOT destroy interval as user" do
    sign_in_as_user
    assert_no_difference('Interval.count') do
      delete interval_url(@interval)
    end
    assert_redirected_to root_path
  end
end
