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
      it 'shows the names of the top 5 customers by number of successful transactions' do
        cus1 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 3)
        cus2 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 4)
        cus3 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 1) # cus 3 not in top
        cus4 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 2)
        cus5 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 5)
        cus6 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 6)
        cus2_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_2, customer: cus2)}
        cus2_unsuccesful_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_1, customer: cus2, invoice_has_success: false)}

        visit "/merchants/#{merchant_1.id}/dashboard"

        within "#top_customers" do
          expect(page).to have_content 'Top Customers'
          expect(cus6.full_name).to appear_before cus5.full_name
          expect(cus5.full_name).to appear_before cus2.full_name
          expect(cus2.full_name).to appear_before cus1.full_name
          expect(cus1.full_name).to appear_before cus4.full_name
        end
      end

      xit 'shows the number of successful transactions next to each customers name' do

      end
    end
  end
end