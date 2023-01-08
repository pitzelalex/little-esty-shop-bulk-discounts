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

      expect(page).to have_link "Admin Merchants Index"

      click_link("Admin Merchants Index")

      expect(current_path).to eq admin_merchants_path
    end

    it 'has a link to the admin invoices index page' do 
      visit admin_index_path 

      expect(page).to have_link "Admin Invoices Index"

      click_link("Admin Invoices Index")
      
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
        # cust5_unsuccessful_invoices = 3.times { create!(:invoice_with_transactions, merchant: merchant_1, customer: customer_5, invoice_has_success: fail)}

        visit admin_index_path 

        within '#top_customers' do 
          expect(customer_2.full_name).to appear_before(customer_5.full_name)
        end
      end

      xit 'shows the number of successful transactions next to each of the top 5 customers' do 

      end
    end
  end
end