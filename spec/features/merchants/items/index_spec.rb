require 'rails_helper'

RSpec.describe 'The merchant items index page', type: :feature do

  let!(:merchant_1) { create(:merchant) }
  let!(:merchant_2) { create(:merchant) }
  let!(:item_1) { create(:item, merchant: merchant_1) }
  let!(:item_2) { create(:item, merchant: merchant_1) }
  let!(:item_3) { create(:item, merchant: merchant_1) }
  let!(:item_4) { create(:item, merchant: merchant_2) }

  describe 'when a user visits a merchants items index page' do
    it 'displays all the names of a merchants items' do
      visit merchant_items_path(merchant_1)

      expect(page).to have_content "Item_1"
      expect(page).to have_content "Item_2"
      expect(page).to have_content "Item_3"
      expect(page).to_not have_content "Item_4"

      visit merchant_items_path(merchant_2)

      expect(page).to_not have_content "Item_1"
      expect(page).to_not have_content "Item_2"
      expect(page).to_not have_content "Item_3"
      expect(page).to have_content "Item_4"
    end
    
    it 'each name is a link to the item show page' do
      visit merchant_items_path(merchant_1)

      merchant_1.items.each do |item|
        expect(page).to have_link item.name, href: merchant_item_path(merchant_1, item)
      end
    end
  end
end