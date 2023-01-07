FactoryBot.define do
  factory :invoice do
    status { 0 }
    association :customer

    trait :completed do
      status { 1 }
    end

    trait :cancelled do
      status { 2 }
    end

    factory :completed_invoice, traits: [:completed]
    factory :cancelled_invoice, traits: [:cancelled]

    factory :invoice_with_items do
      transient do
        merchant { create(:merchant) }
        item_qty { 2 }
        ii_qty { 5 }
        ii_price { 3000 }
      end

      before(:create) do |invoice, opt|
        items = create_list(:item, opt.item_qty, merchant: opt.merchant)
        items.each do |item|
          create(:invoice_item, invoice: invoice, item: item, quantity: opt.ii_qty, unit_price: opt.ii_price)
        end
      end
    end

    factory :invoice_with_successful_transaction do
      after(:create) do |invoice, options|
        create(:successful_transaction, invoice: invoice)
      end
    end
  end
end
