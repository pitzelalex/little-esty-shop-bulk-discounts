require 'rails_helper'

RSpec.describe 'The Admin Merchant Show page', type: :feature do
  let!(:merchant_1) { create(:merchant) }

  describe 'when a user visits the admin merchant show page' do 
    it 'shows the name of the merchant' do 
      visit admin_merchant_path(merchant_1)

      expect(page).to have_content(merchant_1.name)
    end 
  end 
end
