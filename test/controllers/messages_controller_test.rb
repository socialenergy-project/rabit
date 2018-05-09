require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message = messages(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get messages_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
  get messages_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_message_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_message_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create message as admin" do
    sign_in_as_admin
    assert_difference('Message.count') do
      post messages_url, params: { message: { content: @message.content, recipient_id: @message.recipient_id, sender_id: @message.sender_id, status: @message.status } }
    end

    assert_redirected_to message_url(Message.last)
  end

  test "should NOT create message as user" do
    sign_in_as_user
    assert_no_difference('Message.count') do
      post messages_url, params: { message: { content: @message.content, recipient_id: @message.recipient_id, sender_id: @message.sender_id, status: @message.status } }
    end

    assert_redirected_to root_path
  end

  test "should show message as user" do
    sign_in_as_user
    get message_url(@message)
    assert_response :success
  end

  test "should NOT show message as unregistered" do
    get message_url(@message)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_message_url(@message)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_message_url(@message)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update message as admin" do
    sign_in_as_admin
    patch message_url(@message), params: { message: { content: @message.content, recipient_id: @message.recipient_id, sender_id: @message.sender_id, status: @message.status } }
    assert_redirected_to message_url(@message)
  end

  test "should NOT update message as user" do
    sign_in_as_user
    patch message_url(@message), params: { message: { content: @message.content, recipient_id: @message.recipient_id, sender_id: @message.sender_id, status: @message.status } }
    assert_redirected_to root_path
  end

  test "should destroy message as admin" do
    sign_in_as_admin
    assert_difference('Message.count', -1) do
      delete message_url(@message)
    end
    assert_redirected_to messages_url
  end

  test "should NOT destroy message as user" do
    sign_in_as_user
    assert_no_difference('Message.count') do
      delete message_url(@message)
    end
    assert_redirected_to root_path
  end
end
