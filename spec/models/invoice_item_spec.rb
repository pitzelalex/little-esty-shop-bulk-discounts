require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}

    describe 'instance methods' do
      describe '#revenue' do
        it 'returns the total revenue of the invoice item' do
          ii_1 = create(:invoice_item, quantity: 4, unit_price: 20000)
          ii_2 = create(:invoice_item, quantity: 10, unit_price: 12000)

          expect(ii_1.revenue).to eq(80000)
          expect(ii_2.revenue).to eq(120000)
        end
      end
    end
  end
end
