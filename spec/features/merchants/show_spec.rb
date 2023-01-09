require 'rails_helper'

RSpec.describe 'it shows the merchant dashboard page', type: :feature do
  let!(:merchant_1) { create(:merchant) }
  let!(:merchant_2) { create(:merchant) }
  let!(:cus1) { create(:customer_with_success_trans, merchant: merchant_1, inv_count: 3)}
  let!(:cus2) { create(:customer_with_success_trans, merchant: merchant_1, inv_count: 4)}
  let!(:cus3) { create(:customer_with_success_trans, merchant: merchant_1, inv_count: 1)}
  let!(:cus4) { create(:customer_with_success_trans, merchant: merchant_1, inv_count: 2)}
  let!(:cus5) { create(:customer_with_success_trans, merchant: merchant_1, inv_count: 5)}
  let!(:cus6) { create(:customer_with_success_trans, merchant: merchant_1, inv_count: 6)}
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

      it 'shows the number of successful transactions next to each customers name' do
        cus2_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_2, customer: cus2)}
        cus2_unsuccesful_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_1, customer: cus2, invoice_has_success: false)}

        visit "/merchants/#{merchant_1.id}/dashboard"

        within "#customer-#{cus1.id}" do
          expect(page).to have_content 'Number of successful transactions with this merchant: 3'
        end
        within "#customer-#{cus2.id}" do
          expect(page).to have_content 'Number of successful transactions with this merchant: 4'
        end
        within "#customer-#{cus4.id}" do
          expect(page).to have_content 'Number of successful transactions with this merchant: 2'
        end
        within "#customer-#{cus5.id}" do
          expect(page).to have_content 'Number of successful transactions with this merchant: 5'
        end
        within "#customer-#{cus6.id}" do
          expect(page).to have_content 'Number of successful transactions with this merchant: 6'
        end
      end
      describe 'Items Ready to Ship' do
        it 'has a section for items ready to ship that displays the name of all items that are ready to be shipped' do
          mer3 = create(:merchant)
          inv1 = create(:invoice_with_items, merchant: mer3)
          inv2 = create(:invoice_with_items, merchant: mer3)
          ii2_1 = create(:invoice_item, item: mer3.items.first, invoice: inv2, status: 1)

          visit "/merchants/#{mer3.id}/dashboard"

          within "#items_to_ship" do
            expect(page).to have_content('Items Ready to Ship:')
            expect(page).to have_content(mer3.items[0].name)
            expect(page).to have_content(mer3.items[2].name)
          end
        end

        it 'displays the id of the invoices that ordered that item next to each item'

        it 'displays the ids as links to my merchants invoice show page'
      end
    end
  end
end
