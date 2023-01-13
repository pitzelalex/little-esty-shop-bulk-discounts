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

        expect(page).to have_link "My Items", href: merchant_items_path(merchant_2)
        click_link "My Items"

        expect(current_path).to eq merchant_items_path(merchant_2)
      end

      it 'has a link to the merchant invoices index' do
        visit "/merchants/#{merchant_1.id}/dashboard"

        expect(page).to have_link "My Invoices", href: merchant_invoices_path(merchant_1)
        click_link "My Invoices"

        expect(current_path).to eq merchant_invoices_path(merchant_1)
      end
    end

    describe 'Favorite Customers' do
      it 'shows the names of the top 5 customers by number of successful transactions' do
        cus2_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_2, customer: cus2)}
        cus2_unsuccesful_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_1, customer: cus2, invoice_has_success: false)}

        visit "/merchants/#{merchant_1.id}/dashboard"

        within "#top_customers" do
          expect(page).to have_content 'Favourite Customers'
          expect("1. #{cus6.full_name}").to appear_before "2. #{cus5.full_name}"
          expect("2. #{cus5.full_name}").to appear_before "3. #{cus2.full_name}"
          expect("3. #{cus2.full_name}").to appear_before "4. #{cus1.full_name}"
          expect("4. #{cus1.full_name}").to appear_before "5. #{cus4.full_name}"
        end
      end

      it 'shows the number of successful transactions next to each customers name' do
        cus2_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_2, customer: cus2)}
        cus2_unsuccesful_invoices = 5.times { create(:invoice_with_transactions, merchant: merchant_1, customer: cus2, invoice_has_success: false)}

        visit "/merchants/#{merchant_1.id}/dashboard"

        within "#customer-#{cus1.id}" do
          expect(page).to have_content '- 3 purchases'
        end
        within "#customer-#{cus2.id}" do
          expect(page).to have_content '- 4 purchases'
        end
        within "#customer-#{cus4.id}" do
          expect(page).to have_content '- 2 purchases'
        end
        within "#customer-#{cus5.id}" do
          expect(page).to have_content '- 5 purchases'
        end
        within "#customer-#{cus6.id}" do
          expect(page).to have_content '- 6 purchases'
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

        it 'displays the id of the invoices that ordered that item next to each item' do
          mer3 = create(:merchant)
          inv1 = create(:invoice_with_items, merchant: mer3)
          inv2 = create(:invoice_with_items, merchant: mer3)
          create(:invoice_item, item: mer3.items.first, invoice: inv2, status: 1)

          visit "/merchants/#{mer3.id}/dashboard"

          within "#item-#{mer3.items[0].id}" do
            expect(page).to have_content("Shippable Invoices:")
            expect(page).to have_content("Invoice ##{inv1.id}")
            expect(page).to have_content("Invoice ##{inv2.id}")
          end

          within "#item-#{mer3.items[2].id}" do
            expect(page).to have_content("Invoice ##{inv2.id}")
          end
        end

        it 'displays the ids as links to my merchants invoice show page' do
          mer3 = create(:merchant)
          inv1 = create(:invoice_with_items, merchant: mer3)
          inv2 = create(:invoice_with_items, merchant: mer3)
          create(:invoice_item, item: mer3.items.first, invoice: inv2, status: 1)

          visit "/merchants/#{mer3.id}/dashboard"

          within "#item-#{mer3.items[0].id}" do
            expect(page).to have_link "#{inv1.id}", href: merchant_invoice_path(mer3, inv1)
            expect(page).to have_link "#{inv2.id}", href: merchant_invoice_path(mer3, inv2)
          end

          within "#item-#{mer3.items[2].id}" do
            expect(page).to have_link "#{inv2.id}", href: merchant_invoice_path(mer3, inv2)
          end
        end

        it "displays the date formated 'Monday, July 18, 2019' the invoice was created next to each invoice id ordered from oldest to newest" do
          mer3 = create(:merchant)
          inv1 = create(:invoice_with_items, merchant: mer3, created_at: Date.new(2020, 10, 10))
          inv2 = create(:invoice_with_items, merchant: mer3, created_at: Date.new(2020, 9, 10))
          inv3 = create(:invoice_with_items, merchant: mer3, created_at: Date.new(2020, 11, 10))
          create(:invoice_item, item: mer3.items.first, invoice: inv2, status: 1)
          create(:invoice_item, item: mer3.items.first, invoice: inv3, status: 1)

          visit "/merchants/#{mer3.id}/dashboard"

          within "#item-#{mer3.items[0].id}" do
            expect(page).to have_content("Invoice ##{inv1.id} - Saturday, October 10, 2020")
            expect(page).to have_content("Invoice ##{inv2.id} - Thursday, September 10, 2020")
            expect(page).to have_content("Invoice ##{inv3.id} - Tuesday, November 10, 2020")

            expect('Thursday, September 10, 2020').to appear_before('Saturday, October 10, 2020')

            expect('Saturday, October 10, 2020').to appear_before('Tuesday, November 10, 2020')
          end
        end
      end
    end

    describe 'bulk discounts' do
      it 'dislpays a link to view all my discounts that takes me to my discounts index' do
        visit "/merchants/#{merchant_1.id}/dashboard"

        expect(page).to have_link "My Bulk Discounts", href: merchant_bulk_discounts_path(merchant_1)

        click_link "My Bulk Discounts"

        expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1))
      end
    end
  end
end
