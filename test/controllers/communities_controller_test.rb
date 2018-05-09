require 'test_helper'

class CommunitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @community = communities(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get communities_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get communities_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_community_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_community_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create community as admin" do
    sign_in_as_admin
    assert_difference('Community.count') do
      post communities_url, params: { community: { clustering_id: @community.clustering_id, description: @community.description, name: @community.name } }
    end

    assert_redirected_to community_url(Community.last)
  end

  test "should NOT create community as user" do
    sign_in_as_user
    assert_no_difference('Community.count') do
      post communities_url, params: { community: { clustering_id: @community.clustering_id, description: @community.description, name: @community.name } }
    end

    assert_redirected_to root_path
  end

  test "should show community as user" do
    sign_in_as_user
    get community_url(@community)
    assert_response :success
  end

  test "should NOT show community as unregistered" do
    get community_url(@community)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_community_url(@community)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_community_url(@community)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update community as admin" do
    sign_in_as_admin
    patch community_url(@community), params: { community: { clustering_id: @community.clustering_id, description: @community.description, name: @community.name } }
    assert_redirected_to community_url(@community)
  end

  test "should NOT update community as user" do
    sign_in_as_user
    patch community_url(@community), params: { community: { clustering_id: @community.clustering_id, description: @community.description, name: @community.name } }
    assert_redirected_to root_path
  end

  test "should destroy community as admin" do
    sign_in_as_admin
    assert_difference('Community.count', -1) do
      delete community_url(@community)
    end
    assert_redirected_to communities_url
  end

  test "should NOT destroy community as user" do
    sign_in_as_user
    assert_no_difference('Community.count') do
      delete community_url(@community)
    end
    assert_redirected_to root_path
  end
end
