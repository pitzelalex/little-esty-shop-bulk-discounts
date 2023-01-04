FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant_#{n}" }

    trait :disabled do 
      status { 0 }
    end
    
    trait :enabled do 
      status { 1 }
    end

    factory :disabled_merchant, traits: [:disabled]
    factory :enabled_merchant, traits: [:enabled]

    factory :merchant_with_items do
      transient do
        num { 4 }
      end

      before(:create) do |merchant, evaluator|
        evaluator.num.times do |t| 
          create(:item, merchant: merchant)
        end
      end
    end

    factory :merchant_with_invoices do
      transient do
        item_num { 4 }
        invoice_num { 2 }
      end

      before(:create) do |merchant, evaluator|
        evaluator.item_num.times do |t|
          item = create(:item, merchant: merchant)
          invoice = create(:invoice)
          create(:invoice_item, item: item, invoice: invoice)
        end
      end
    end
  end
end
