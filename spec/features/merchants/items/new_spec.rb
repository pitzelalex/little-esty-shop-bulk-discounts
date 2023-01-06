require 'rails_helper'

RSpec.describe 'Merchant Item New page', type: :feature do

  let!(:merchant_1) { create(:merchant_with_items) }

  describe 'Form to create a new item' do
    it 'has a form to create a new item' do
      visit new_merchant_item_path(merchant_1)

      expect(page).to have_field "Name"
      expect(page).to have_field "Description"
      expect(page).to have_field "item[unit_price]"
      expect(page).to have_button "Create Item"
    end

    it 'upon submission, redirects back to the items index page and shows new disabled item' do
      visit new_merchant_item_path(merchant_1)

      fill_in "item[name]", with: 'New Item'
      fill_in "item[description]", with: 'Test description'
      fill_in "item[unit_price]", with: 11111
      click_button "Create Item"

      expect(current_path).to eq merchant_items_path(merchant_1)

      within("#disabled_items") do
        expect(page).to have_content "New Item"
      end
    end
  end
end