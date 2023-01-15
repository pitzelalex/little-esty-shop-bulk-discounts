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

    describe '#discounted_revenue' do
      it 'returns the total revenue after discounts for an invoice' do
        merchant = create(:merchant_with_items, num: 3)
        merchant2 = create(:merchant_with_items, num: 3)
        # require 'pry'; binding.pry
        invoice = create(:invoice)
        ii1 = create(:invoice_item, item: merchant.items[0], invoice: invoice, quantity: 20, unit_price: 100000) # 1_600_000
        ii2 = create(:invoice_item, item: merchant.items[1], invoice: invoice, quantity: 10, unit_price: 100000) # 900_000
        ii3 = create(:invoice_item, item: merchant.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 500_000
        ii4 = create(:invoice_item, item: merchant2.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 400_000
        bd1 = create(:bulk_discount, threshold: 10, discount: 0.90, merchant: merchant)
        bd2 = create(:bulk_discount, threshold: 20, discount: 0.80, merchant: merchant)
        bd3 = create(:bulk_discount, threshold: 5, discount: 0.80, merchant: merchant2)

        expect(invoice.discounted_revenue_for(merchant)).to eq(3_000_000)
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
