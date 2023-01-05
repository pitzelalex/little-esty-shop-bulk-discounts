require 'rails_helper'

RSpec.describe 'The merchant invocie show page', type: :feature do
  let(:merchant_1) { create(:merchant_with_invoices) }

  describe "I visit one of my merchant's invoice show pages" do
    it "Displays information about that invoice" do
      merchant_1.invoices.each do |invoice|
        visit merchant_invoice_path(merchant_1, invoice)

        expect(page).to have_content("Id: #{invoice.id}")
        expect(page).to have_content("Status: #{invoice.status}")
        expect(page).to have_content("Created at: #{invoice.created_at.strftime("%A, %B%e, %Y")}")
        expect(page).to have_content("Customer: #{invoice.customer.first_name} #{invoice.customer.last_name}")
      end
    end
  end
end
