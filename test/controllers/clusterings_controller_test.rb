require 'test_helper'

class ClusteringsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clustering = clusterings(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get clusterings_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get clusterings_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_clustering_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_clustering_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create clustering as admin" do
    sign_in_as_admin
    assert_difference('Clustering.count') do
      post clusterings_url, params: { clustering: { description: @clustering.description, name: @clustering.name } }
    end

    assert_redirected_to clustering_url(Clustering.last)
  end

  test "should NOT create clustering as user" do
    sign_in_as_user
    assert_no_difference('Clustering.count') do
      post clusterings_url, params: { clustering: { description: @clustering.description, name: @clustering.name } }
    end

    assert_redirected_to root_path
  end

  test "should show clustering as user" do
    sign_in_as_user
    get clustering_url(@clustering)
    assert_response :success
  end

  test "should NOT show clustering as unregistered" do
    get clustering_url(@clustering)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_clustering_url(@clustering)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_clustering_url(@clustering)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update clustering as admin" do
    sign_in_as_admin
    patch clustering_url(@clustering), params: { clustering: { description: @clustering.description, name: @clustering.name } }
    assert_redirected_to clustering_url(@clustering)
  end

  test "should NOT update clustering as user" do
    sign_in_as_user
    patch clustering_url(@clustering), params: { clustering: { description: @clustering.description, name: @clustering.name } }
    assert_redirected_to root_path
  end

  test "should destroy clustering as admin" do
    sign_in_as_admin
    assert_difference('Clustering.count', -1) do
      delete clustering_url(@clustering)
    end
    assert_redirected_to clusterings_url
  end

  test "should NOT destroy clustering as user" do
    sign_in_as_user
    assert_no_difference('Clustering.count') do
      delete clustering_url(@clustering)
    end
    assert_redirected_to root_path
  end
end
