require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:merchants).through(:invoices) }
    it { should have_many(:items).through(:invoices) }

    describe 'instance methods' do
      describe '#full_name' do
        it 'returns the customers full name' do
          customer = Customer.create!(first_name: 'Alex', last_name: 'Pitzel')

          expect(customer.full_name).to eq('Alex Pitzel')
        end
      end
    end
  end

  describe 'top_5_customers' do
    it 'determines the top 5 customers with successful transactions' do 
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:enabled_merchant)
      customer_1 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 3)
      customer_2 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 8)
      customer_3 = create(:customer_with_success_trans, merchant: merchant_2, inv_count: 5)
      customer_4 = create(:customer_with_success_trans, merchant: merchant_2, inv_count: 2)
      customer_5 = create(:customer_with_success_trans, merchant: merchant_1, inv_count: 7)
      customer_6 = create(:customer_with_success_trans, merchant: merchant_3, inv_count: 4)
      3.times { create(:invoice_with_transactions, merchant: merchant_1, customer: customer_5, invoice_has_success: false)}
      3.times { create(:invoice_with_transactions, merchant: merchant_3, customer: customer_6, invoice_has_success: false)}

      expect(Customer.top_5_customers).to eq([customer_2, customer_5, customer_3, customer_6, customer_1])
      expect(Customer.top_5_customers).not_to include(customer_4)
    end
  end
end
