require 'application_system_test_case'

class DrActionsTest < ApplicationSystemTestCase
  setup do
    @dr_action = dr_actions(:one)
  end

  test 'visiting the index' do
    visit dr_actions_url
    assert_selector 'h1', text: 'Dr Actions'
  end

  test 'creating a Dr action' do
    visit dr_actions_url
    click_on 'New Dr Action'

    fill_in 'Consumer', with: @dr_action.consumer_id
    fill_in 'Dr target', with: @dr_action.dr_target_id
    fill_in 'Price per mw', with: @dr_action.price_per_mw
    fill_in 'Volume actual', with: @dr_action.volume_actual
    fill_in 'Volume planned', with: @dr_action.volume_planned
    click_on 'Create Dr action'

    assert_text 'Dr action was successfully created'
    click_on 'Back'
  end

  test 'updating a Dr action' do
    visit dr_actions_url
    click_on 'Edit', match: :first

    fill_in 'Consumer', with: @dr_action.consumer_id
    fill_in 'Dr target', with: @dr_action.dr_target_id
    fill_in 'Price per mw', with: @dr_action.price_per_mw
    fill_in 'Volume actual', with: @dr_action.volume_actual
    fill_in 'Volume planned', with: @dr_action.volume_planned
    click_on 'Update Dr action'

    assert_text 'Dr action was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Dr action' do
    visit dr_actions_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Dr action was successfully destroyed'
  end
end
