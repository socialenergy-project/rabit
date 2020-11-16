require 'test_helper'

class ConsumerCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consumer_category = consumer_categories(:one)
  end

  test 'should get index as user' do
    sign_in_as_user
    get consumer_categories_url
    assert_response :success
  end

  test 'should NOT get index as unregistered' do
    get consumer_categories_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get new as admin' do
    sign_in_as_admin
    get new_consumer_category_url
    assert_response :success
  end

  test 'should NOT get new as user' do
    sign_in_as_user
    get new_consumer_category_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should create consumer_category as admin' do
    sign_in_as_admin
    assert_difference('ConsumerCategory.count') do
      post consumer_categories_url, params: { consumer_category: { description: @consumer_category.description, name: @consumer_category.name, real_time: @consumer_category.real_time } }
    end

    assert_redirected_to consumer_category_url(ConsumerCategory.last)
  end

  test 'should NOT create consumer_category as user' do
    sign_in_as_user
    assert_no_difference('ConsumerCategory.count') do
      post consumer_categories_url, params: { consumer_category: { description: @consumer_category.description, name: @consumer_category.name, real_time: @consumer_category.real_time } }
    end

    assert_redirected_to root_path
  end

  test 'should show consumer_category as user' do
    sign_in_as_user
    get consumer_category_url(@consumer_category)
    assert_response :success
  end

  test 'should NOT show consumer_category as unregistered' do
    get consumer_category_url(@consumer_category)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get edit as admin' do
    sign_in_as_admin
    get edit_consumer_category_url(@consumer_category)
    assert_response :success
  end

  test 'should NOT get edit as user' do
    sign_in_as_user
    get edit_consumer_category_url(@consumer_category)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should update consumer_category as admin' do
    sign_in_as_admin
    patch consumer_category_url(@consumer_category), params: { consumer_category: { description: @consumer_category.description, name: @consumer_category.name, real_time: @consumer_category.real_time } }
    assert_redirected_to consumer_category_url(@consumer_category)
  end

  test 'should NOT update consumer_category as user' do
    sign_in_as_user
    patch consumer_category_url(@consumer_category), params: { consumer_category: { description: @consumer_category.description, name: @consumer_category.name, real_time: @consumer_category.real_time } }
    assert_redirected_to root_path
  end

  test 'should destroy empty consumer_category as admin' do
    sign_in_as_admin
    @consumer_category.consumers.delete_all
    assert_difference('ConsumerCategory.count', -1) do
      delete consumer_category_url(@consumer_category)
    end
    assert_redirected_to consumer_categories_url
  end

  test 'should NOT destroy consumer_category as admin' do
    sign_in_as_admin
    assert_no_difference('ConsumerCategory.count') do
      delete consumer_category_url(@consumer_category)
    end
    assert_redirected_to consumer_categories_url
  end

  test 'should NOT destroy consumer_category as user' do
    sign_in_as_user
    assert_no_difference('ConsumerCategory.count') do
      delete consumer_category_url(@consumer_category)
    end
    assert_redirected_to root_path
  end
end
