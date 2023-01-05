require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:customers).through(:invoices)}

    describe 'instance methods' do
      describe '#invoice_items_by_invoice' do
        it 'returns an items invoice items based on a specific invoice' do
          invoice_1 = create(:invoice)
          invoice_2 = create(:invoice)
          item_1 = create(:item_with_invoice_item, invoice: invoice_1)
          item_2 = create(:item_with_invoice_item, invoice: invoice_2)

          # require 'pry'; binding.pry
          expect(item_1.invoice_items_by_invoice(invoice_1)).to eq(InvoiceItem.find(Invoice.first.id))
        end
      end
    end
  end
end
