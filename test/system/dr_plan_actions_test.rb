require "application_system_test_case"

class DrPlanActionsTest < ApplicationSystemTestCase
  setup do
    @dr_plan_action = dr_plan_actions(:one)
  end

  test "visiting the index" do
    visit dr_plan_actions_url
    assert_selector "h1", text: "Dr Plan Actions"
  end

  test "creating a Dr plan action" do
    visit dr_plan_actions_url
    click_on "New Dr Plan Action"

    fill_in "Consumer", with: @dr_plan_action.consumer_id
    fill_in "Dr target", with: @dr_plan_action.dr_target_id
    fill_in "Price per mw", with: @dr_plan_action.price_per_mw
    fill_in "Volume planned", with: @dr_plan_action.volume_planned
    click_on "Create Dr plan action"

    assert_text "Dr plan action was successfully created"
    click_on "Back"
  end

  test "updating a Dr plan action" do
    visit dr_plan_actions_url
    click_on "Edit", match: :first

    fill_in "Consumer", with: @dr_plan_action.consumer_id
    fill_in "Dr target", with: @dr_plan_action.dr_target_id
    fill_in "Price per mw", with: @dr_plan_action.price_per_mw
    fill_in "Volume planned", with: @dr_plan_action.volume_planned
    click_on "Update Dr plan action"

    assert_text "Dr plan action was successfully updated"
    click_on "Back"
  end

  test "destroying a Dr plan action" do
    visit dr_plan_actions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dr plan action was successfully destroyed"
  end
end
