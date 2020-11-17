require 'test_helper'

<% module_namespacing do -%>
class <%= controller_class_name %>ControllerTest < ActionDispatch::IntegrationTest
  <%- if mountable_engine? -%>
  include Engine.routes.url_helpers

  <%- end -%>
  setup do
    @<%= singular_table_name %> = <%= fixture_name %>(:one)
  end

  test "should get index as user" do
    sign_in_as_admin
    get <%= index_helper %>_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get <%= index_helper %>_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get <%= new_helper %>
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get <%= new_helper %>
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create <%= singular_table_name %> as admin" do
    sign_in_as_admin
    assert_difference('<%= class_name %>.count') do
      post <%= index_helper %>_url, params: { <%= "#{singular_table_name}: { #{attributes_hash} }" %> }
    end

    assert_redirected_to <%= singular_table_name %>_url(<%= class_name %>.last)
  end

  test "should NOT create <%= singular_table_name %> as user" do
    sign_in_as_user
    assert_no_difference('<%= class_name %>.count') do
      post <%= index_helper %>_url, params: { <%= "#{singular_table_name}: { #{attributes_hash} }" %> }
    end

    assert_redirected_to root_path
  end

  test "should show <%= singular_table_name %> as user" do
    sign_in_as_user
    get <%= show_helper %>
    assert_response :success
  end

  test "should NOT show <%= singular_table_name %> as unregistered" do
    get <%= show_helper %>
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get <%= edit_helper %>
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get <%= edit_helper %>
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update <%= singular_table_name %> as admin" do
    sign_in_as_admin
    patch <%= show_helper %>, params: { <%= "#{singular_table_name}: { #{attributes_hash} }" %> }
    assert_redirected_to <%= singular_table_name %>_url(<%= "@#{singular_table_name}" %>)
  end

  test "should NOT update <%= singular_table_name %> as user" do
    sign_in_as_user
    patch <%= show_helper %>, params: { <%= "#{singular_table_name}: { #{attributes_hash} }" %> }
    assert_redirected_to root_path
  end

  test "should destroy <%= singular_table_name %> as admin" do
    sign_in_as_admin
    assert_difference('<%= class_name %>.count', -1) do
      delete <%= show_helper %>
    end
    assert_redirected_to <%= index_helper %>_url
  end

  test "should NOT destroy <%= singular_table_name %> as user" do
    sign_in_as_user
    assert_no_difference('<%= class_name %>.count') do
      delete <%= show_helper %>
    end
    assert_redirected_to root_path
  end
end
<% end -%>
