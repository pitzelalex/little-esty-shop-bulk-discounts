require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Admin Invoice Show Page' do
  before(:each) do
    @invoice_1 = create(:invoice)
    @invoice_item = create(:invoice_item, invoice: @invoice_1)
  end

  describe 'When I visit an admin invoice show page' do
    it 'has information related to that invoice' do
      visit admin_invoice_path(@invoice_1)

      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_content('Status:')
      expect(page).to have_content("Created at: #{@invoice_1.created_at.strftime('%A, %B%e, %Y')}")
      expect(page).to have_content("Customer: #{@invoice_1.customer.first_name} #{@invoice_1.customer.last_name}")
    end

    it 'has all the items on the invoice and their properties' do
      visit admin_invoice_path(@invoice_1)

      within '#items' do
        expect(page).to have_content('Items on this Invoice:')
        @invoice_1.items.each do |item|
          within "#item-#{item.id}" do
            expect(page).to have_content("#{item.name}")
            expect(page).to have_content("#{item.invoice_items.where(invoice_id: @invoice_1.id).first.quantity}")
            expect(page).to have_content("#{number_to_currency(item.invoice_items.where(invoice_id: @invoice_1.id).first.unit_price / 100.00)}")
            expect(page).to have_content("#{item.invoice_items.where(invoice_id: @invoice_1.id).first.status}")
          end
        end
      end
    end

    it 'displays the total revenue generated from this invoice' do
      visit admin_invoice_path(@invoice_1)

      expect(page).to have_content("Total Revenue: #{number_to_currency(@invoice_1.total_revenue / 100.00)}")
    end

    it 'has invoice status as a select field and the current status is selected' do
      visit admin_invoice_path(@invoice_1)

      expect(page).to have_select('invoice[status]', selected: "#{@invoice_1.status}")
      expect(page).to have_select('invoice[status]', options: ['', 'in progress', 'cancelled', 'completed'])
    end

    it "has a button to 'Update Invoice Status' which updates the invoice status when clicked" do
      visit admin_invoice_path(@invoice_1)

      expect(@invoice_1.status).to eq('in progress')

      select('completed', from: 'invoice[status]')
      click_button('Update Invoice Status')

      @invoice_1.reload

      expect(@invoice_1.status).to eq('completed')
      expect(page).to have_select('invoice[status]', selected: 'completed')

      expect(current_path).to eq(admin_invoice_path(@invoice_1))
    end

    it 'displays the discounted revenue for all items on the invoice' do
      merchant = create(:merchant_with_items, num: 3)
      merchant2 = create(:merchant_with_items, num: 3)
      invoice = create(:invoice)
      ii1 = create(:invoice_item, item: merchant.items[0], invoice: invoice, quantity: 20, unit_price: 100000) # 1_600_000
      ii2 = create(:invoice_item, item: merchant.items[1], invoice: invoice, quantity: 10, unit_price: 100000) # 900_000
      ii3 = create(:invoice_item, item: merchant.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 500_000
      ii4 = create(:invoice_item, item: merchant2.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 400_000
      ii5 = create(:invoice_item, item: merchant2.items[1], invoice: invoice, quantity: 15, unit_price: 100000) # 1_050_000
      bd1 = create(:bulk_discount, threshold: 10, discount: 0.90, merchant: merchant)
      bd2 = create(:bulk_discount, threshold: 20, discount: 0.80, merchant: merchant)
      bd3 = create(:bulk_discount, threshold: 5, discount: 0.80, merchant: merchant2)
      bd4 = create(:bulk_discount, threshold: 10, discount: 0.70, merchant: merchant2)

      visit admin_invoice_path(invoice)

      expect(page).to have_content('Total Revenue after discounts: $44,500.00')
    end
  end
end
