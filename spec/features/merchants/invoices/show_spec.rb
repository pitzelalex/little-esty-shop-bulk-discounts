require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'The merchant invocie show page', type: :feature do
  let(:merchant_1) { create(:merchant_with_invoices) }
  let(:merchant_2) { create(:merchant_with_invoices) }

  describe "I visit one of my merchant's invoice show pages" do
    it "Displays information about that invoice" do
      merchant_1.invoices.each do |invoice|
        visit merchant_invoice_path(merchant_1, invoice)

        expect(page).to have_content("Id: #{invoice.id}")
        expect(page).to have_content("Status: #{invoice.status}")
        expect(page).to have_content("Created at: #{invoice.created_at.strftime("%A, %B %-d, %Y")}")
        expect(page).to have_content("Customer: #{invoice.customer.first_name} #{invoice.customer.last_name}")
      end
    end

    it "Displays a list of all that invoice's items with my merchant and their details" do
      merchant_1.invoices.group(:id).each do |invoice|
        visit merchant_invoice_path(merchant_1, invoice)
        within "#items" do
          invoice.items.each do |item|
            within "#item-#{item.id}" do
              expect(page).to have_content(item.name)
              expect(page).to have_content("Quantity ordered: #{item.invoice_items.where(invoice_id: invoice.id).first.quantity}")
              expect(page).to have_content("Sale price: #{number_to_currency((item.invoice_items.where(invoice_id: invoice.id).first.unit_price)/100.00)}")
            end
          end
          merchant_2.invoices.group(:id).each do |invoice|
            invoice.items.each do |item|
              expect(page).not_to have_content(item.name)
            end
          end
        end
      end
    end

    it 'displays the total revenue that will be generated from all of my items on the invoice' do
      merchant_3 = create(:merchant)
      invoice_1 = create(:invoice_with_items, item_count: 2, ii_qty: 5, ii_price: 3000, merchant: merchant_3)
      invoice_2 = create(:invoice_with_items, item_count: 3, ii_qty: 2, ii_price: 2500, merchant: merchant_3)

      visit merchant_invoice_path(merchant_3, invoice_1)

      expect(page).to have_content("Total revenue: $300.00")

      visit merchant_invoice_path(merchant_3, invoice_2)

      expect(page).to have_content("Total revenue: $150.00")
    end

    it 'has a status drop down for each status with a default selection of the current status' do
      invoice = merchant_1.invoices.first

      visit merchant_invoice_path(merchant_1, invoice)

      invoice.items.each do |item|
        within "#item-#{item.id}" do
          expect(page).to have_select('invoice_item[status]', selected: item.invoice_item_by_invoice(invoice).status)
          expect(page).to have_select('invoice_item[status]', options: ['', 'pending','packaged', 'shipped'])
        end
      end
    end

    it "has a button to 'Update Item Status' which updates the invoice item status when clicked" do
      invoice = merchant_1.invoices.first
      item_1 = invoice.items.first

      visit merchant_invoice_path(merchant_1, invoice)

      invoice.items.each do |item|
        within "#item-#{item.id}" do
          expect(page).to have_button 'Update Item Status'
        end
      end

      within "#item-#{item_1.id}" do
        select 'packaged', from: 'invoice_item[status]'
        click_button('Update Item Status')
      end

      expect(current_path).to eq(merchant_invoice_path(merchant_1, invoice))

      within "#item-#{item_1.id}" do
        expect(page).to have_select('invoice_item[status]', selected: 'packaged')
      end

      expect(item_1.invoice_item_by_invoice(invoice).status).to eq('packaged')

      within "#item-#{item_1.id}" do
        select '', from: 'invoice_item[status]'
        click_button('Update Item Status')
      end

      expect(page).to have_content("Status can't be blank")
    end
  end
end
