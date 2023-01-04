require 'rails_helper'

RSpec.describe 'The Admin Merchant Index page', type: :feature do
  let!(:merchant_1) { create(:merchant) }
  let!(:merchant_2) { create(:merchant) }
  let!(:merchant_3) { create(:merchant) }

  describe 'when a user visits the admin merchant index page' do 
    it 'lists the name of each merchant in the system' do 
      visit admin_merchants_path

      expect(page).to have_content(merchant_1.name)
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
    end

    it 'has a link for each merchant name to the admin merchant show page' do
      visit admin_merchants_path

      expect(page).to have_link(merchant_1.name)
      expect(page).to have_link(merchant_2.name)
      expect(page).to have_link(merchant_3.name)

      click_link(merchant_1.name)

      expect(current_path).to eq(admin_merchants_path(merchant_1))
    end
  end
end