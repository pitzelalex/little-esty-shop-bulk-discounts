require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :feature do 

  let!(:merchant_1) { create(:merchant) }
  let!(:merchant_2) { create(:merchant) }
  let!(:merchant_3) { create(:enabled_merchant) }

  describe 'when the user visits the admin dashboard' do 
    it 'shows a header indicating the user is on the admin dashboard' do 
      visit admin_index_path 

      expect(page).to have_content("Admin Dashboard")
    end 

    it 'has a link to the admin merchants index page' do 
      visit admin_index_path 

      expect(page).to have_link "Merchants"

      click_link("Merchants")

      expect(current_path).to eq admin_merchants_path
    end

    it 'has a link to the admin invoices index page' do 
      visit admin_index_path 

      expect(page).to have_link "Invoices"

      click_link("Invoices")
      
      expect(current_path).to eq admin_invoices_path
    end

    describe 'top customers' do 
      it 'displays the top 5 customers by successful transaction' do
        customer_1 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 3)
        customer_2 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 8)
        customer_3 = create(:customer_with_success_trans, merchant: merchant_2, inv_count: 5)
        customer_4 = create(:customer_with_success_trans, merchant: merchant_2, inv_count: 2)
        customer_5 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 7)
        customer_6 = create(:customer_with_success_trans, merchant: merchant_3, inv_count: 4)
        cust5_unsuccessful_invoices = 3.times { create(:invoice_with_transactions, merchant: merchant_1, customer: customer_5, invoice_has_success: false)}
        cust6_unsuccessful_invoices = 3.times { create(:invoice_with_transactions, merchant: merchant_3, customer: customer_6, invoice_has_success: false)}

        visit admin_index_path 

        within '#top_customers' do 
          expect(customer_2.first_name).to appear_before(customer_5.first_name)
          expect(customer_5.first_name).to appear_before(customer_3.first_name)
          expect(customer_3.first_name).to appear_before(customer_6.first_name)
          expect(customer_6.first_name).to appear_before(customer_1.first_name)
          expect(page).to_not have_content(customer_4.first_name)
        end
      end

      it 'shows the number of successful transactions next to each of the top 5 customers' do 
        customer_1 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 3)
        customer_2 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 8)
        customer_3 = create(:customer_with_success_trans, merchant: merchant_2, inv_count: 5)
        customer_4 = create(:customer_with_success_trans, merchant: merchant_2, inv_count: 2)
        customer_5 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 7)
        customer_6 = create(:customer_with_success_trans, merchant: merchant_3, inv_count: 4)
        cust5_unsuccessful_invoices = 3.times { create(:invoice_with_transactions, merchant: merchant_1, customer: customer_5, invoice_has_success: false)}
        cust6_unsuccessful_invoices = 3.times { create(:invoice_with_transactions, merchant: merchant_3, customer: customer_6, invoice_has_success: false)}

        visit admin_index_path 

        within '#top_customers' do 
          expect(page).to have_content("1. #{customer_2.first_name} #{customer_2.last_name} - 8 purchases")
          expect(page).to have_content("2. #{customer_5.first_name} #{customer_5.last_name} - 7 purchases")
          expect(page).to have_content("3. #{customer_3.first_name} #{customer_3.last_name} - 5 purchases")
          expect(page).to have_content("4. #{customer_6.first_name} #{customer_6.last_name} - 4 purchases")
          expect(page).to have_content("5. #{customer_1.first_name} #{customer_1.last_name} - 3 purchases")
        end
      end
    end

    describe 'incomplete invoices' do 
      it 'has a section for incomplete invoices with items that have not been shipped' do 
        inv1 = create(:invoice_with_items)
        inv2 = create(:invoice_with_items)
        inv3 = create(:invoice)
        ii1 = create(:invoice_item, invoice: inv3, status: 2)
        ii2 = create(:invoice_item, invoice: inv3, status: 2)

        visit admin_index_path 

        within '#incomplete_invoices' do 
          expect(page).to have_content(inv1.id)
          expect(page).to have_content(inv2.id)
          expect(page).to_not have_content(inv3.id)
        end
      end

      it "has a link to the invoice's admin show page for each invoice id" do 
        inv1 = create(:invoice_with_items)
        inv2 = create(:invoice_with_items)
        inv3 = create(:invoice)
        ii1 = create(:invoice_item, invoice: inv3, status: 2)
        ii2 = create(:invoice_item, invoice: inv3, status: 2)

        visit admin_index_path 

        within "#incomplete_invoices_#{inv1.id}" do 
          expect(page).to have_link "#{inv1.id}"
          click_link inv1.id
        end

        expect(current_path).to eq admin_invoice_path(inv1)

        visit admin_index_path 

        within "#incomplete_invoices_#{inv2.id}" do 
          expect(page).to have_link "#{inv2.id}"
          click_link inv2.id
        end

        expect(current_path).to eq admin_invoice_path(inv2)
      end

      it 'displays the date for each incomplete invoice ordered from oldest to newest' do 
          inv1 = create(:invoice_with_items, created_at: Date.new(2018,8,04))
          inv2 = create(:invoice_with_items, created_at: Date.new(2021,12,20))
          inv3 = create(:invoice_with_items, created_at: Date.new(2019,3,21))
          inv4 = create(:invoice, created_at: Date.new(2017,2,10))
          ii1 = create(:invoice_item, invoice: inv4, status: 2)
          ii2 = create(:invoice_item, invoice: inv4, status: 2)
  
          visit admin_index_path 

          within '#incomplete_invoices' do 
            expect(page).to have_content("Invoice ##{inv1.id} - Saturday, August 4, 2018")
            expect(page).to have_content("Invoice ##{inv3.id} - Thursday, March 21, 2019")
            expect(page).to have_content("Invoice ##{inv2.id} - Monday, December 20, 2021")
            expect(page).to_not have_content(inv4.id)
          end
        end 

      it 'will sort the incomplete invoices from oldest to newest' do 
        inv1 = create(:invoice_with_items, created_at: Date.new(2018,8,04))
        inv2 = create(:invoice_with_items, created_at: Date.new(2021,12,20))
        inv3 = create(:invoice_with_items, created_at: Date.new(2019,3,21))
        inv4 = create(:invoice)
        ii1 = create(:invoice_item, invoice: inv4, status: 2)
        ii2 = create(:invoice_item, invoice: inv4, status: 2)

        visit admin_index_path 

        within '#incomplete_invoices' do 
          expect("#{inv1.id}").to appear_before("#{inv3.id}")
          expect("#{inv3.id}").to appear_before("#{inv2.id}")
          expect(page).to_not have_content(inv4.id)
        end
      end
    end
  end
end