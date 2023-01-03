require 'rails_helper'

RSpec.describe 'it shows the merchant dashboard page', type: :feature do
  
  let!(:merchant_1) { Merchant.create!(name: "KDavis") }
  let!(:merchant_2) { Merchant.create!(name: "APitzel") }

  describe 'when a user visits the merchant dashboard' do
    it 'shows the name of the merchant' do
      visit "/merchants/#{merchant_1.id}/dashboard"

      expect(current_path).to eq "/merchants/#{merchant_1.id}/dashboard"
      expect(page).to have_content "KDavis"
      expect(page).to_not have_content "APitzel"
    end
  end
end