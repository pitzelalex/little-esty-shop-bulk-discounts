require 'rails_helper'

RSpec.describe 'The Merchant item edit page', type: :feature do

  let!(:merchant_1) { create(:merchant_with_items) }
  let!(:merchant_2) { create(:merchant_with_items) }

  describe 'when a merchant visits an item edit page' do
    it 'has a form filled in with existing item attributes' do
      item = merchant_1.items.first
      visit edit_merchant_item_path(merchant_1, item)

      expect(page).to have_field("item[name]", with: "#{item.name}")
      expect(page).to have_field("item[description]", with: "#{item.description}")
      expect(page).to have_field("item[unit_price]", with: "#{item.unit_price}")
    end

    it 'redirects back to the item show page with updated information when successfully updated' do
      item = merchant_1.items.first
      visit edit_merchant_item_path(merchant_1, item)

      fill_in "item[name]", with: "New Name"
      click_button "Submit"

      expect(current_path).to eq merchant_item_path(merchant_1, item)
      expect(page).to have_content "Item Information Successfully Updated"
      expect(page).to have_content "Name: New Name"
      expect(page).to have_content "Description: Description_1"
      expect(page).to have_content "Unit Price: 11000"

      item = merchant_2.items.first
      visit edit_merchant_item_path(merchant_2, item)

      fill_in "item[name]", with: "New Name"
      fill_in "item[unit_price]", with: 11111
      click_button "Submit"

      expect(current_path).to eq merchant_item_path(merchant_2, item)
      expect(page).to have_content "Item Information Successfully Updated"
      expect(page).to have_content "Name: New Name"
      expect(page).to have_content "Description: Description_5"
      expect(page).to have_content "Unit Price: 11111"
    end

    it 'redirects back to the item edit page if information is incorrectly filled in after clicking submit' do
      item = merchant_2.items.first
      visit edit_merchant_item_path(merchant_2, item)

      fill_in "item[name]", with: ""
      fill_in "item[unit_price]", with: "Not a Price"
      click_button "Submit"

      expect(page).to have_content "Name can't be blank and Unit price is not a number"
      expect(current_path).to eq edit_merchant_item_path(merchant_2, item)
    end
  end
end