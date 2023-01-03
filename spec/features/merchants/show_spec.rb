require 'rails_helper'

RSpec.describe 'it shows the merchant dashboard page', type: :feature do

  let!(:merchant_1) { create(:merchant) }
  let!(:merchant_2) { create(:merchant) }

  describe 'when a user visits the merchant dashboard' do
    it 'shows the name of the merchant' do
      visit "/merchants/#{merchant_1.id}/dashboard"

      expect(current_path).to eq "/merchants/#{merchant_1.id}/dashboard"
      expect(page).to have_content "Merchant_1"
      expect(page).to_not have_content "Merchant_2"

      visit "/merchants/#{merchant_2.id}/dashboard"

      expect(current_path).to eq "/merchants/#{merchant_2.id}/dashboard"
      expect(page).to_not have_content "Merchant_1"
      expect(page).to have_content "Merchant_2"
    end

    describe 'dashboard navigation' do
      it 'has a link to the merchants items index' do
        visit "/merchants/#{merchant_2.id}/dashboard"

        expect(page).to have_link "Items Index", href: "/merchants/#{merchant_2.id}/items"
      end

      it 'has a link to the merchant invoices index' do
        visit "/merchants/#{merchant_1.id}/dashboard"

        expect(page).to have_link "Invoice Index", href: "/merchants/#{merchant_1.id}/invoices"
      end
    end

    describe 'Favorite Customers' do
      xit 'shows the names of the top 5 customers by number of successful transactions' do
        visit "/merchants/#{merchant_1.id}/dashboard"

        expect(page).to have_content ""
      end

      xit 'shows the number of successful transactions next to each customers name' do

      end
    end
  end
end