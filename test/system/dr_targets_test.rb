require "application_system_test_case"

class DrTargetsTest < ApplicationSystemTestCase
  setup do
    @dr_target = dr_targets(:one)
  end

  test "visiting the index" do
    visit dr_targets_url
    assert_selector "h1", text: "Dr Targets"
  end

  test "creating a Dr target" do
    visit dr_targets_url
    click_on "New Dr Target"

    fill_in "Cleared price", with: @dr_target.cleared_price
    fill_in "Dr event", with: @dr_target.dr_event_id
    fill_in "Ts offset", with: @dr_target.ts_offset
    fill_in "Volume", with: @dr_target.volume
    click_on "Create Dr target"

    assert_text "Dr target was successfully created"
    click_on "Back"
  end

  test "updating a Dr target" do
    visit dr_targets_url
    click_on "Edit", match: :first

    fill_in "Cleared price", with: @dr_target.cleared_price
    fill_in "Dr event", with: @dr_target.dr_event_id
    fill_in "Ts offset", with: @dr_target.ts_offset
    fill_in "Volume", with: @dr_target.volume
    click_on "Update Dr target"

    assert_text "Dr target was successfully updated"
    click_on "Back"
  end

  test "destroying a Dr target" do
    visit dr_targets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dr target was successfully destroyed"
  end
end
