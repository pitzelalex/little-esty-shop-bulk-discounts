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
    it 'returns the top 5 customers with the most successful transactions' do
      mer1 = create(:merchant)
      cus1 = create(:customer_with_success_trans, merchant: mer1, inv_count: 3)
      cus2 = create(:customer_with_success_trans, merchant: mer1, inv_count: 4)
      cus3 = create(:customer_with_success_trans, merchant: mer1, inv_count: 1) # cus 3 not in top
      cus4 = create(:customer_with_success_trans, merchant: mer1, inv_count: 2)
      cus5 = create(:customer_with_success_trans, merchant: mer1, inv_count: 5)
      cus6 = create(:customer_with_success_trans, merchant: mer1, inv_count: 6)

      expect(mer1.top_customers).to eq([cus6, cus5, cus2, cus1, cus4])
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
