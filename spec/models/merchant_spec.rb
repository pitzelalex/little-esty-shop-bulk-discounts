require 'rails_helper'

RSpec.describe Merchant, type: :model do

  let!(:merchant_1) { Merchant.create!(name: "KDavis") }

  describe "relationships" do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:customers).through(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe 'top_customers' do
    xit 'returns the top 5 customers with the most successful transactions' do
      expect(merchant_1.top_customers).to eq([])
    end
  end
end
