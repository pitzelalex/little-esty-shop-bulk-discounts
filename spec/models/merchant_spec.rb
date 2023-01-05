require 'rails_helper'

RSpec.describe Merchant, type: :model do

  let!(:merchant_1) { Merchant.create!(name: "KDavis", status: 0) }
  let!(:merchant_2) { create(:disabled_merchant) }
  let!(:merchant_3) { create(:disabled_merchant) }
  let!(:merchant_4) { create(:disabled_merchant) }
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
