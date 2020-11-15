require "application_system_test_case"

class DrEventsTest < ApplicationSystemTestCase
  setup do
    @dr_event = dr_events(:one)
  end

  test "visiting the index" do
    visit dr_events_url
    assert_selector "h1", text: "Dr Events"
  end

  test "creating a Dr event" do
    visit dr_events_url
    click_on "New Dr Event"

    fill_in "Interval", with: @dr_event.interval_id
    fill_in "Name", with: @dr_event.name
    fill_in "Price", with: @dr_event.price
    fill_in "Starttime", with: @dr_event.starttime
    fill_in "State", with: @dr_event.state
    fill_in "Type", with: @dr_event.type
    click_on "Create Dr event"

    assert_text "Dr event was successfully created"
    click_on "Back"
  end

  test "updating a Dr event" do
    visit dr_events_url
    click_on "Edit", match: :first

    fill_in "Interval", with: @dr_event.interval_id
    fill_in "Name", with: @dr_event.name
    fill_in "Price", with: @dr_event.price
    fill_in "Starttime", with: @dr_event.starttime
    fill_in "State", with: @dr_event.state
    fill_in "Type", with: @dr_event.type
    click_on "Update Dr event"

    assert_text "Dr event was successfully updated"
    click_on "Back"
  end

  test "destroying a Dr event" do
    visit dr_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dr event was successfully destroyed"
  end
end
