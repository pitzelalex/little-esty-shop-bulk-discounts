require 'rails_helper'

RSpec.describe Merchant, type: :model do

  let!(:merchant_1) { Merchant.create!(name: "KDavis", status: 0) }
  let!(:merchant_2) { create(:merchant) }
  let!(:merchant_3) { create(:merchant) }
  let!(:merchant_4) { create(:merchant) }
  let!(:merchant_5) { create(:enabled_merchant) }
  let!(:merchant_6) { create(:enabled_merchant) }
  let!(:merchant_7) { create(:enabled_merchant) }

  describe "relationships" do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:customers).through(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe 'top_customers' do
    xit 'returns the top 5 customers with the most successful transactions' do
      expect(merchant_1.top_customers).to eq([])
    end
  end

  describe 'top_items' do
    it 'returns the top 5 items and their total revenue in ascending order by revenue for a merchant' do
      #factorybot revenue per invoice is 50000
      item_1 = create(:item_with_successful_transaction, number_of_invoices: 5, merchant: merchant_2)
      item_2 = create(:item_with_successful_transaction, number_of_invoices: 1, merchant: merchant_2)
      item_3 = create(:item_with_successful_transaction, number_of_invoices: 3, merchant: merchant_2)
      item_4 = create(:item_with_successful_transaction, number_of_invoices: 6, merchant: merchant_2)
      item_5 = create(:item_with_successful_transaction, number_of_invoices: 2, merchant: merchant_2)
      item_6 = create(:item_with_successful_transaction, number_of_invoices: 4, merchant: merchant_2)
      item_7 = create(:item_with_successful_transaction, merchant: merchant_3)
      
      expect(merchant_2.top_items).to eq [item_4, item_1, item_6, item_3, item_5]
      expect(merchant_2.top_items[0].revenue).to eq 300000 
      expect(merchant_2.top_items[4].revenue).to eq 100000
    end
  end

  describe 'disabled status' do
    it 'can set the merchant status to disabled' do
      expect(merchant_1.status).to eq("disabled")
    end
  end

  describe 'enabled status' do
    it 'can set the merchant status to enabled' do
      expect(merchant_5.status).to eq("enabled")
    end
  end

  describe 'class methods' do
    describe 'enabled merchants' do
      it 'sorts the merchants with status as enabled' do
        expect(Merchant.enabled_merchants).to eq([merchant_5, merchant_6, merchant_7])
      end
    end

    describe 'disabled merchants' do
      it 'sorts the merchants with status as disabled' do
        expect(Merchant.disabled_merchants).to eq([merchant_1, merchant_2, merchant_3, merchant_4])
      end
    end
  end
end
