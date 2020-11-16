require 'test_helper'

class EccTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ecc_type = ecc_types(:one)
  end

  test 'should get index as user' do
    sign_in_as_user
    get ecc_types_url
    assert_response :success
  end

  test 'should NOT get index as unregistered' do
    get ecc_types_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get new as admin' do
    sign_in_as_admin
    get new_ecc_type_url
    assert_response :success
  end

  test 'should NOT get new as user' do
    sign_in_as_user
    get new_ecc_type_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should create ecc_type as admin' do
    sign_in_as_admin
    assert_difference('EccType.count') do
      post ecc_types_url, params: { ecc_type: { name: @ecc_type.name, consumer_id: consumers(:two).id } }
    end
    assert_redirected_to ecc_type_url(EccType.last)
  end

  test 'should NOT create ecc_type as user' do
    sign_in_as_user
    assert_no_difference('EccType.count') do
      post ecc_types_url, params: { ecc_type: { name: @ecc_type.name } }
    end

    assert_redirected_to root_path
  end

  test 'should show ecc_type as user' do
    sign_in_as_user
    get ecc_type_url(@ecc_type)
    assert_response :success
  end

  test 'should NOT show ecc_type as unregistered' do
    get ecc_type_url(@ecc_type)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get edit as admin' do
    sign_in_as_admin
    get edit_ecc_type_url(@ecc_type)
    assert_response :success
  end

  test 'should NOT get edit as user' do
    sign_in_as_user
    get edit_ecc_type_url(@ecc_type)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should update ecc_type as admin' do
    sign_in_as_admin
    patch ecc_type_url(@ecc_type), params: { ecc_type: { name: @ecc_type.name } }
    assert_redirected_to ecc_type_url(@ecc_type)
  end

  test 'should NOT update ecc_type as user' do
    sign_in_as_user
    patch ecc_type_url(@ecc_type), params: { ecc_type: { name: @ecc_type.name } }
    assert_redirected_to root_path
  end

  test 'should destroy ecc_type as admin' do
    sign_in_as_admin
    assert_difference('EccType.count', -1) do
      delete ecc_type_url(@ecc_type)
    end
    assert_redirected_to consumer_url(@ecc_type.consumer)
  end

  test 'should NOT destroy ecc_type as user' do
    sign_in_as_user
    assert_no_difference('EccType.count') do
      delete ecc_type_url(@ecc_type)
    end
    assert_redirected_to root_path
  end
end
