require 'test_helper'

class EnergyProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @energy_program = energy_programs(:one)
  end

  test "should get index as user" do
    sign_in_as_user
    get energy_programs_url
    assert_response :success
  end

  test "should NOT get index as unregistered" do
    get energy_programs_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new as admin" do
    sign_in_as_admin
    get new_energy_program_url
    assert_response :success
  end

  test "should NOT get new as user" do
    sign_in_as_user
    get new_energy_program_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create energy_program as admin" do
    sign_in_as_admin
    assert_difference('EnergyProgram.count') do
      post energy_programs_url, params: {energy_program: {name: @energy_program.name}}
    end

    assert_redirected_to energy_program_url(EnergyProgram.last)
  end

  test "should NOT create energy_program as user" do
    sign_in_as_user
    assert_no_difference('EnergyProgram.count') do
      post energy_programs_url, params: {energy_program: {name: @energy_program.name}}
    end

    assert_redirected_to root_path
  end

  test "should show energy_program as user" do
    sign_in_as_user
    get energy_program_url(@energy_program)
    assert_response :success
  end

  test "should NOT show energy_program as unregistered" do
    get energy_program_url(@energy_program)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit as admin" do
    sign_in_as_admin
    get edit_energy_program_url(@energy_program)
    assert_response :success
  end

  test "should NOT get edit as user" do
    sign_in_as_user
    get edit_energy_program_url(@energy_program)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should update energy_program as admin" do
    sign_in_as_admin
    patch energy_program_url(@energy_program), params: {energy_program: {name: @energy_program.name}}
    assert_redirected_to energy_program_url(@energy_program)
  end

  test "should NOT update energy_program as user" do
    sign_in_as_user
    patch energy_program_url(@energy_program), params: {energy_program: {name: @energy_program.name}}
    assert_redirected_to root_path
  end

  test "should destroy energy_program as admin" do
    sign_in_as_admin
    assert_difference('EnergyProgram.count', -1) do
      delete energy_program_url(@energy_program)
    end
    assert_redirected_to energy_programs_url
  end

  test "should NOT destroy energy_program as user" do
    sign_in_as_user
    assert_no_difference('EnergyProgram.count') do
      delete energy_program_url(@energy_program)
    end
    assert_redirected_to root_path
  end
end
