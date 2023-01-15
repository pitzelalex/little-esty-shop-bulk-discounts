require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :unit_price }
  end

  describe 'instance methods' do
    describe '#invoice_items_by_invoice' do
      it 'returns an items invoice items based on a specific invoice' do
        invoice_1 = create(:invoice)
        invoice_2 = create(:invoice)
        item_1 = create(:item)
        item_2 = create(:item)
        ii_1 = create(:invoice_item, item: item_1, invoice: invoice_1)
        ii_2 = create(:invoice_item, item: item_2, invoice: invoice_2)

        expect(item_1.invoice_item_by_invoice(invoice_1)).to eq(ii_1)
        expect(item_1.invoice_item_by_invoice(invoice_1)).not_to eq(ii_2)
        expect(item_2.invoice_item_by_invoice(invoice_2)).to eq(ii_2)
        expect(item_2.invoice_item_by_invoice(invoice_2)).not_to eq(ii_1)
      end
    end

    describe '#date_with_most_sales' do
      it 'returns the date an item had the most sales' do
        merchant_1 = create(:merchant)
        item_1 = create(:item_with_dated_invoices, merchant: merchant_1)
        item_2 = create(:item_with_dated_invoices, date_offset: 2.years + 2.month, merchant: merchant_1)

        expect(item_1.date_with_most_sales.strftime('%A, %B %-d, %Y')).to eq 'Thursday, December 8, 2022'
        expect(item_2.date_with_most_sales.strftime('%A, %B %-d, %Y')).to eq 'Sunday, November 8, 2020'
      end
    end

    describe '#shippable_invoices' do
      it 'returns the invoices that have an invoice item with this item that is packaged' do
        inv1 = create(:invoice)
        inv2 = create(:invoice)
        inv3 = create(:invoice)
        item = create(:packaged_item, invoice: inv1)
        create(:invoice_item, item: item, invoice: inv2)
        create(:packaged_ii, item: item, invoice: inv3)

        expect(item.shippable_invoices).to eq([inv1, inv3])
      end
    end

    describe '#bulk_discount' do
      it 'returns the bulk discount this item qualifies for' do
        merchant = create(:merchant_with_items, num: 3)
        invoice = create(:invoice)
        ii1 = create(:invoice_item, item: merchant.items[0], invoice: invoice, quantity: 20, unit_price: 100000) # 1_600_000
        ii2 = create(:invoice_item, item: merchant.items[1], invoice: invoice, quantity: 10, unit_price: 100000) # 900_000
        ii3 = create(:invoice_item, item: merchant.items[2], invoice: invoice, quantity: 5, unit_price: 100000) # 500_000
        bd1 = create(:bulk_discount, threshold: 10, discount: 0.90, merchant: merchant)
        bd2 = create(:bulk_discount, threshold: 20, discount: 0.80, merchant: merchant)

        expect(merchant.items[0].bulk_discount(invoice)).to eq(bd2)
        expect(merchant.items[1].bulk_discount(invoice)).to eq(bd1)
        expect(merchant.items[2].bulk_discount(invoice)).to eq(nil)
      end
    end
  end
end
