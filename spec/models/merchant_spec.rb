require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :items}
    it {should have_many(:invoices).through(:items)}
  end

  describe 'top_customers' do
    it 'returns the top 5 customers with the most successful transactions' do
      expect(:merchant_1).to eq([])
    end
  end
end
