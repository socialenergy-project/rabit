require 'test_helper'

class DataPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data_point = data_points(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get data_points_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get data_points_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_data_point_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_data_point_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create data_point as admin" do
    sign_in_as_admin
    assert_difference('DataPoint.count') do
      post data_points_url, params: { data_point: { consumer_id: @data_point.consumer_id, consumption: @data_point.consumption, flexibility: @data_point.flexibility, interval_id: @data_point.interval_id, timestamp: @data_point.timestamp + @data_point.interval.duration.seconds } }
    end

    assert_redirected_to data_point_url(DataPoint.last)
  end

  test "should NOT create data_point as user" do
    sign_in_as_user
    assert_no_difference('DataPoint.count') do
      post data_points_url, params: { data_point: { consumer_id: @data_point.consumer_id, consumption: @data_point.consumption, flexibility: @data_point.flexibility, interval_id: @data_point.interval_id, timestamp: @data_point.timestamp } }
    end

    assert_redirected_to root_path
  end

  test "should show data_point as user" do
    sign_in_as_user
    get data_point_url(@data_point)
    assert_response :success
  end

  test "should NOT show data_point as unregistered" do
    get data_point_url(@data_point)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_data_point_url(@data_point)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_data_point_url(@data_point)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update data_point as admin" do
    sign_in_as_admin
    patch data_point_url(@data_point), params: { data_point: { consumer_id: @data_point.consumer_id, consumption: @data_point.consumption, flexibility: @data_point.flexibility, interval_id: @data_point.interval_id, timestamp: @data_point.timestamp } }
    assert_redirected_to data_point_url(@data_point)
  end

  test "should NOT update data_point as user" do
    sign_in_as_user
    patch data_point_url(@data_point), params: { data_point: { consumer_id: @data_point.consumer_id, consumption: @data_point.consumption, flexibility: @data_point.flexibility, interval_id: @data_point.interval_id, timestamp: @data_point.timestamp } }
    assert_redirected_to root_path
  end

  test "should destroy data_point as admin" do
    sign_in_as_admin
    assert_difference('DataPoint.count', -1) do
      delete data_point_url(@data_point)
    end
    assert_redirected_to data_points_url
  end

  test "should NOT destroy data_point as user" do
    sign_in_as_user
    assert_no_difference('DataPoint.count') do
      delete data_point_url(@data_point)
    end
    assert_redirected_to root_path
  end
end
