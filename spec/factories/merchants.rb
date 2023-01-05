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
        invoice_num { 2 }
        item_num { 2 }
      end

      before(:create) do |merchant, evaluator|
        evaluator.invoice_num.times do 
          items = create_list(:item, evaluator.item_num, merchant: merchant)
          invoice = create(:invoice)
          items.each do |item|
            create(:invoice_item, item: item, invoice: invoice)
          end
        end
      end
    end
  end
end