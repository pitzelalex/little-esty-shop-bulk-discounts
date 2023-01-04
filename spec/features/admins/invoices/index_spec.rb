require 'rails_helper'

RSpec.describe 'The Admin Invoices Index' do
    before(:each) do
        @invoice_1 = create(:invoice)
        @invoice_2 = create(:invoice)
        @invoice_3 = create(:invoice)
    end

    describe 'When I visit the admin invoices index' do
        it 'lists the ids of all invoices in the system' do
            visit admin_invoices_path

            expect(page).to have_content("Invoice ##{@invoice_1.id}")
            expect(page).to have_content("Invoice ##{@invoice_2.id}")
            expect(page).to have_content("Invoice ##{@invoice_3.id}")
        end

        it 'has links to each invoice show page for each respective ID' do
            visit admin_invoices_path
            
            expect(page).to have_link("Invoice ##{@invoice_1.id}")
            expect(page).to have_link("Invoice ##{@invoice_2.id}")
            expect(page).to have_link("Invoice ##{@invoice_3.id}")

            click_link("Invoice ##{@invoice_1.id}")

            expect(current_path).to eq(admin_invoices_path(@invoice_1))
        end
    end
end