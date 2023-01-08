FactoryBot.define do
  factory :customer do
    sequence(:first_name) { |n| "first_name #{n}" }
    sequence(:last_name) { |n| "last_name #{n}" }

    factory :customer_with_success_trans do 
      transient do 
        inv_count { 2 }
        merchant { create(:merchant) }
      end

      before(:create) do |customer, opt|
        invs = create_list(:invoice_with_transactions, opt.inv_count, merchant: opt.merchant, customer: customer)
      end
    end
  end
end
