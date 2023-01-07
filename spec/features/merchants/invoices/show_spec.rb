require 'rails_helper'

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
              expect(page).to have_content("Sale price: #{item.invoice_items.where(invoice_id: invoice.id).first.unit_price}")
              expect(page).to have_content("Status: #{item.invoice_items.where(invoice_id: invoice.id).first.status}")
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
  end
end
