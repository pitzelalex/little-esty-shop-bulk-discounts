require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
    before(:each) do
        @invoice_1 = create(:invoice)
        @invoice_item = create(:invoice_item, invoice: @invoice_1)
    end

    describe 'When I visit an admin invoice show page' do
        it 'has information related to that invoice' do
            visit admin_invoice_path(@invoice_1)

            expect(page).to have_content("Invoice ##{@invoice_1.id}")
            expect(page).to have_content("Status: #{@invoice_1.status}")
            expect(page).to have_content("Created at: #{@invoice_1.created_at.strftime("%A, %B%e, %Y")}")
            expect(page).to have_content("Customer: #{@invoice_1.customer.first_name} #{@invoice_1.customer.last_name}")
        end

        it 'has all the items on the invoice and their properties' do
            visit admin_invoice_path(@invoice_1)

            expect(page).to have_content(@invoice_1.items.first.name)
            expect(page).to have_content(@invoice_1.items.last.name)

            expect(page).to have_content(@invoice_1.items.first.invoice_item_by_invoice(@invoice_1).quantity)
            expect(page).to have_content(@invoice_1.items.last.invoice_item_by_invoice(@invoice_1).quantity)
            expect(page).to have_content(@invoice_1.items.first.invoice_item_by_invoice(@invoice_1).unit_price)
            expect(page).to have_content(@invoice_1.items.last.invoice_item_by_invoice(@invoice_1).unit_price)
            expect(page).to have_content(@invoice_1.items.first.invoice_item_by_invoice(@invoice_1).status)
            expect(page).to have_content(@invoice_1.items.last.invoice_item_by_invoice(@invoice_1).status)
        end

        it 'displays the total revenue generated from this invoice' do
            visit admin_invoice_path(@invoice_1)

            expect(page).to have_content("Total Revenue: #{@invoice_1.total_revenue}")
        end

        it 'has invoice status as a select field and the current status is selected' do
            visit admin_invoice_path(@invoice_1)

            expect(page).to have_select('invoice[status]', selected: "#{@invoice_1.status}")
            expect(page).to have_select('invoice[status]', options: ['in progress', 'cancelled', 'completed'])
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
    end
end