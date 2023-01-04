require 'rails_helper'

RSpec.describe 'The merchant items show page', type: :feature do
  
  let!(:merchant_1) { create(:merchant_with_items) }
  let!(:merchant_2) { create(:merchant_with_items) }

  describe 'when a merchant navigates to an items show page' do
    it 'displays the items name, description, and current selling price' do
      visit merchant_item_path(merchant_1, merchant_1.items.first)

      expect(page).to have_content "Name: Item_1"    
      expect(page).to have_content "Description: Description_1"    
      expect(page).to have_content "Unit Price: 11000"    
      expect(page).to_not have_content "Name: Item_2"    
      expect(page).to_not have_content "Description: Description_2"    
    end
  end
end