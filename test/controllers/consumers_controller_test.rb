require 'test_helper'

class ConsumersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consumer = consumers(:one)
  end

  test 'should get index as user' do
    sign_in_as_user
    get consumers_url
    assert_response :success
  end

  test 'should NOT get index as unregistered' do
    get consumers_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get new as admin' do
    sign_in_as_admin
    get new_consumer_url
    assert_response :success
  end

  test 'should NOT get new as user' do
    sign_in_as_user
    get new_consumer_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should create consumer as admin' do
    sign_in_as_admin
    assert_difference('Consumer.count') do
      post consumers_url, params: { consumer: { building_type_id: @consumer.building_type_id, connection_type_id: @consumer.connection_type_id, consumer_category_id: @consumer.consumer_category_id, edms_id: "#{@consumer.edms_id}_2", feeder_id: @consumer.feeder_id, location: @consumer.location, location_x: @consumer.location_x, location_y: @consumer.location_y, name: @consumer.name } }
    end

    assert_redirected_to consumer_url(Consumer.last)
  end

  test 'should NOT create consumer as user' do
    sign_in_as_user
    assert_no_difference('Consumer.count') do
      post consumers_url, params: { consumer: { building_type_id: @consumer.building_type_id, connection_type_id: @consumer.connection_type_id, consumer_category_id: @consumer.consumer_category_id, edms_id: @consumer.edms_id, feeder_id: @consumer.feeder_id, location: @consumer.location, location_x: @consumer.location_x, location_y: @consumer.location_y, name: @consumer.name } }
    end

    assert_redirected_to root_path
  end

  test 'should show consumer as user' do
    sign_in_as_user
    get consumer_url(@consumer)
    assert_response :success
  end

  test 'should NOT show consumer as unregistered' do
    get consumer_url(@consumer)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get edit as admin' do
    sign_in_as_admin
    get edit_consumer_url(@consumer)
    assert_response :success
  end

  test 'should NOT get edit as user' do
    sign_in_as_user
    get edit_consumer_url(@consumer)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should update consumer as admin' do
    sign_in_as_admin
    patch consumer_url(@consumer), params: { consumer: { building_type_id: @consumer.building_type_id, connection_type_id: @consumer.connection_type_id, consumer_category_id: @consumer.consumer_category_id, edms_id: @consumer.edms_id, feeder_id: @consumer.feeder_id, location: @consumer.location, location_x: @consumer.location_x, location_y: @consumer.location_y, name: @consumer.name } }
    assert_redirected_to consumer_url(@consumer)
  end

  test 'should NOT update consumer as user' do
    sign_in_as_user
    patch consumer_url(@consumer), params: { consumer: { building_type_id: @consumer.building_type_id, connection_type_id: @consumer.connection_type_id, consumer_category_id: @consumer.consumer_category_id, edms_id: @consumer.edms_id, feeder_id: @consumer.feeder_id, location: @consumer.location, location_x: @consumer.location_x, location_y: @consumer.location_y, name: @consumer.name } }
    assert_redirected_to root_path
  end

  test 'should destroy consumer as admin' do
    sign_in_as_admin
    assert_difference('Consumer.count', -1) do
      delete consumer_url(consumers(:four))
    end
    assert_redirected_to consumers_url
  end

  test 'should NOT destroy consumer with dr_actions as admin' do
    sign_in_as_admin
    assert_no_difference('Consumer.count', -1) do
      delete consumer_url(@consumer)
    end
    assert_redirected_to consumers_url
  end

  test 'should NOT destroy consumer as user' do
    sign_in_as_user
    assert_no_difference('Consumer.count') do
      delete consumer_url(@consumer)
    end
    assert_redirected_to root_path
  end
end
