require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it {should have_many :invoices}
    it {should have_many :transactions}

    define 'instance methods' do
      define '#full_name' do
        it 'returns the customers full name' do
          customer = create(:customer, first_name: 'Alex', last_name: 'Pitzel')

          expect(customer.full_name).to eq('Alex Pitzel')
        end
      end
    end
  end
end
