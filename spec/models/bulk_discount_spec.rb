require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'instance methods' do
    describe '#discount_percentage' do
      it 'returns a readable discount percentage from the discount field' do
        merchant_1 = create(:merchant)
        bd_1 = create(:bulk_discount, threshold: 5, discount: 0.90, merchant: merchant_1)
        bd_2 = create(:bulk_discount, threshold: 10, discount: 0.80, merchant: merchant_1)

        expect(bd_1.discount_percentage).to eq(10)
        expect(bd_2.discount_percentage).to eq(20)
      end
    end
  end
end
