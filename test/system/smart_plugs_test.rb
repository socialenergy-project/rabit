require "application_system_test_case"

class SmartPlugsTest < ApplicationSystemTestCase
  setup do
    @smart_plug = smart_plugs(:one)
  end

  test "visiting the index" do
    visit smart_plugs_url
    assert_selector "h1", text: "Smart Plugs"
  end

  test "creating a Smart plug" do
    visit smart_plugs_url
    click_on "New Smart Plug"

    fill_in "Consumer", with: @smart_plug.consumer_id
    fill_in "Mqtt name", with: @smart_plug.mqtt_name
    fill_in "Name", with: @smart_plug.name
    click_on "Create Smart plug"

    assert_text "Smart plug was successfully created"
    click_on "Back"
  end

  test "updating a Smart plug" do
    visit smart_plugs_url
    click_on "Edit", match: :first

    fill_in "Consumer", with: @smart_plug.consumer_id
    fill_in "Mqtt name", with: @smart_plug.mqtt_name
    fill_in "Name", with: @smart_plug.name
    click_on "Update Smart plug"

    assert_text "Smart plug was successfully updated"
    click_on "Back"
  end

  test "destroying a Smart plug" do
    visit smart_plugs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Smart plug was successfully destroyed"
  end
end
