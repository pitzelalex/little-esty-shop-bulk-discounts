require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many :transactions}
    it {should have_many(:merchants).through(:items)}
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it 'returns the total revenue for an invoice' do
        invoice_1 = create(:invoice_with_items, item_qty: 2, ii_qty: 5, ii_price: 3000)
        invoice_2 = create(:invoice_with_items, item_qty: 3, ii_qty: 2, ii_price: 2500)

        expect(invoice_1.total_revenue).to eq(30000)
        expect(invoice_2.total_revenue).to eq(15000)
      end
    end
  end
end
