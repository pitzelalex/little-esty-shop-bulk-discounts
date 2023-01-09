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
        invoice_1 = create(:invoice_with_items, item_count: 2, ii_qty: 5, ii_price: 3000)
        invoice_2 = create(:invoice_with_items, item_count: 3, ii_qty: 2, ii_price: 2500)

        expect(invoice_1.total_revenue).to eq(30000)
        expect(invoice_2.total_revenue).to eq(15000)
      end
    end
  end

  describe 'class methods' do 
    describe 'incomplete_invoices' do 
      it 'returns the invoices with items not yet shipped in order from oldest to youngest' do 
        inv1 = create(:invoice_with_items, created_at: Date.new(2018,8,04))
        inv2 = create(:invoice_with_items, created_at: Date.new(2021,12,20))
        inv3 = create(:invoice_with_items, created_at: Date.new(2019,3,21))
        inv4 = create(:invoice)
        ii1 = create(:invoice_item, invoice: inv4, status: 2)
        ii2 = create(:invoice_item, invoice: inv4, status: 2)
      
        expect(Invoice.incomplete_invoices).to eq([inv1, inv3, inv2])
      end
    end
  end
end
