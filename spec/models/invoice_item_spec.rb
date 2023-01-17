require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
    it { should have_many(:transactions).through(:invoice) }
  end

  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'instance methods' do
    describe '#revenue' do
      it 'returns the total revenue of the invoice item' do
        ii_1 = create(:invoice_item, quantity: 4, unit_price: 20000)
        ii_2 = create(:invoice_item, quantity: 10, unit_price: 12000)

        expect(ii_1.revenue).to eq(80000)
        expect(ii_2.revenue).to eq(120000)
      end
    end

    # describe '#discounted_revenue' do
    #   it 'returns the total discounted revenue of the invoice item' do
    #     merchant = create(:merchant_with_items, num: 3)
    #     invoice = create(:invoice)
    #     ii1 = create(:invoice_item, item: merchant.items[0], invoice: invoice, quantity: 20, unit_price: 100000) # 1_600_000
    #     ii2 = create(:invoice_item, item: merchant.items[1], invoice: invoice, quantity: 10, unit_price: 100000) # 900_000
    #     ii3 = create(:invoice_item, item: merchant.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 500_000
    #     bd1 = create(:bulk_discount, threshold: 10, discount: 0.90, merchant: merchant)
    #     bd2 = create(:bulk_discount, threshold: 20, discount: 0.80, merchant: merchant)

    #     expect(ii1.discounted_revenue).to eq(1600000)
    #     expect(ii2.discounted_revenue).to eq(900000)
    #     expect(ii3.discounted_revenue).to eq(500000)
    #   end
    # end

    describe '#discount' do
      it 'returns the decimal value of the appropriate discount that applies to an invoice item' do
        merchant = create(:merchant_with_items, num: 3)
        invoice = create(:invoice)
        ii1 = create(:invoice_item, item: merchant.items[0], invoice: invoice, quantity: 20, unit_price: 100000) # 1_600_000
        ii2 = create(:invoice_item, item: merchant.items[1], invoice: invoice, quantity: 10, unit_price: 100000) # 900_000
        ii3 = create(:invoice_item, item: merchant.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 500_000
        bd1 = create(:bulk_discount, threshold: 10, discount: 0.90, merchant: merchant)
        bd2 = create(:bulk_discount, threshold: 20, discount: 0.80, merchant: merchant)

        expect(ii1.discount).to eq(0.80)
        expect(ii2.discount).to eq(0.90)
        expect(ii3.discount).to eq(nil)
      end
    end

    describe '#invoice_discount' do
      it 'returns the discounted total from an invoice_items total' do
        merchant = create(:merchant_with_items, num: 3)
        invoice = create(:invoice)
        ii1 = create(:invoice_item, item: merchant.items[0], invoice: invoice, quantity: 20, unit_price: 100000) # 1_600_000
        ii2 = create(:invoice_item, item: merchant.items[1], invoice: invoice, quantity: 10, unit_price: 100000) # 900_000
        ii3 = create(:invoice_item, item: merchant.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 500_000
        bd1 = create(:bulk_discount, threshold: 10, discount: 0.90, merchant: merchant)
        bd2 = create(:bulk_discount, threshold: 20, discount: 0.80, merchant: merchant)

        totals = merchant.invoice_items.where(invoice_id: invoice.id).select('invoice_items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total').group(:id)

        expect(totals[0].invoice_discount).to eq(1_600_000)
        expect(totals[1].invoice_discount).to eq(900_000)
        expect(totals[2].invoice_discount).to eq(500_000)
      end
    end
  end
end
