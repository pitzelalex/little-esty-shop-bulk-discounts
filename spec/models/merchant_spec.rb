require 'rails_helper'

RSpec.describe Merchant, type: :model do

  let!(:merchant_1) { Merchant.create!(name: "KDavis", status: 0) }
  let!(:merchant_2) { create(:merchant) }
  let!(:merchant_3) { create(:merchant) }
  let!(:merchant_4) { create(:merchant) }
  let!(:merchant_5) { create(:enabled_merchant) }
  let!(:merchant_6) { create(:enabled_merchant) }
  let!(:merchant_7) { create(:enabled_merchant) }

  let!(:invoice_1) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_1, transaction_qty: 1)}
  let!(:invoice_2) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_1, transaction_qty: 1)}
  let!(:invoice_3) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_1, transaction_qty: 1)}
  let!(:invoice_4) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_1, transaction_qty: 1)}

  let!(:invoice_5) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_2, transaction_qty: 2)}
  let!(:invoice_6) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_2, transaction_qty: 2)}
  let!(:invoice_7) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_2, transaction_qty: 2)}

  let!(:invoice_8) { create(:invoice_with_transactions, invoice_has_success: false, merchant: merchant_3, transaction_qty: 2)}
  let!(:invoice_9) { create(:invoice_with_transactions, invoice_has_success: false, merchant: merchant_3, transaction_qty: 2)}
  let!(:invoice_10) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_3, transaction_qty: 2)}

  let!(:invoice_11) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_4, transaction_qty: 1)}
  let!(:invoice_12) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_4, transaction_qty: 1)}

  let!(:invoice_13) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_5, transaction_qty: 2)}
  let!(:invoice_14) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_5, transaction_qty: 2)}
  let!(:invoice_15) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_5, transaction_qty: 2)}
  let!(:invoice_16) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_5, transaction_qty: 2)}
  let!(:invoice_17) { create(:invoice_with_transactions, invoice_has_success: false, merchant: merchant_5, transaction_qty: 2)}
  let!(:invoice_18) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_5, transaction_qty: 2)}

  let!(:invoice_19) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_6, transaction_qty: 1)}
  let!(:invoice_20) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_6, transaction_qty: 1)}
  let!(:invoice_21) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_6, transaction_qty: 1)}
  let!(:invoice_22) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_6, transaction_qty: 1)}
  let!(:invoice_23) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_6, transaction_qty: 1)}
  let!(:invoice_24) { create(:invoice_with_transactions, invoice_has_success: true, merchant: merchant_6, transaction_qty: 1)}

  let!(:invoice_25) { create(:invoice_with_transactions, invoice_has_success: false, merchant: merchant_7, transaction_qty: 1)}

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

    describe 'top 5 merchants' do 
      it 'determines the top 5 merchants by total revenue with at least 1 successful transaction' do 
        expect(Merchant.top_five_merchants).to eq([merchant_6, merchant_5, merchant_1, merchant_2, merchant_4])
      end
    end
  end
end
