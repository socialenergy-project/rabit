require "application_system_test_case"

class EccTypesTest < ApplicationSystemTestCase
  setup do
    @ecc_type = ecc_types(:one)
  end

  test "visiting the index" do
    visit ecc_types_url
    assert_selector "h1", text: "Ecc Types"
  end

  test "creating a Ecc type" do
    visit ecc_types_url
    click_on "New Ecc Type"

    fill_in "Energy down per day", with: @ecc_type.energy_down_per_day
    fill_in "Energy up per day", with: @ecc_type.energy_up_per_day
    fill_in "Max activation time per activation", with: @ecc_type.max_activation_time_per_activation
    fill_in "Max activation time per day", with: @ecc_type.max_activation_time_per_day
    fill_in "Max activations per day", with: @ecc_type.max_activations_per_day
    fill_in "Minimum activation time", with: @ecc_type.minimum_activation_time
    fill_in "Ramp down rate", with: @ecc_type.ramp_down_rate
    fill_in "Ramp up rate", with: @ecc_type.ramp_up_rate
    click_on "Create Ecc type"

    assert_text "Ecc type was successfully created"
    click_on "Back"
  end

  test "updating a Ecc type" do
    visit ecc_types_url
    click_on "Edit", match: :first

    fill_in "Energy down per day", with: @ecc_type.energy_down_per_day
    fill_in "Energy up per day", with: @ecc_type.energy_up_per_day
    fill_in "Max activation time per activation", with: @ecc_type.max_activation_time_per_activation
    fill_in "Max activation time per day", with: @ecc_type.max_activation_time_per_day
    fill_in "Max activations per day", with: @ecc_type.max_activations_per_day
    fill_in "Minimum activation time", with: @ecc_type.minimum_activation_time
    fill_in "Ramp down rate", with: @ecc_type.ramp_down_rate
    fill_in "Ramp up rate", with: @ecc_type.ramp_up_rate
    click_on "Update Ecc type"

    assert_text "Ecc type was successfully updated"
    click_on "Back"
  end

  test "destroying a Ecc type" do
    visit ecc_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ecc type was successfully destroyed"
  end
end
