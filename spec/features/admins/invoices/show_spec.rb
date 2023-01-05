require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
    before(:each) do
        @invoice_1 = create(:invoice)
    end

    describe 'When I visit an admin invoice show page' do
        it 'has information related to that invoice' do
            visit admin_invoice_path(@invoice_1)

            expect(page).to have_content("Invoice ##{@invoice_1.id}")
            expect(page).to have_content("Status: #{@invoice_1.status}")
            expect(page).to have_content("Created at: #{@invoice_1.created_at.strftime("%A, %B%e, %Y")}")
            expect(page).to have_content("Customer: #{@invoice_1.customer.first_name} #{@invoice_1.customer.last_name}")
        end
    end
end