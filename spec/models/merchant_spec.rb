require 'rails_helper'

RSpec.describe Merchant, type: :model do

  let!(:merchant_1) { Merchant.create!(name: "KDavis", status: 0) }
  let!(:merchant_2) { create(:enabled_merchant) }

  describe "relationships" do
    it {should have_many :items}
    it {should have_many(:invoices).through(:items)}
    it {should have_many(:customers).through(:invoices)}
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
      expect(merchant_2.status).to eq("enabled")
    end
  end
end
