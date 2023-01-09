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

    transient do
      date_offset { 1.month}
    end
    trait :dated do
      created_at { Date.new(2023, 01, 8) - date_offset}
    end

    factory :completed_invoice, traits: [:completed]
    factory :cancelled_invoice, traits: [:cancelled]

    factory :invoice_with_items do
      transient do
        merchant { create(:merchant) }
        item_count { 2 }
        ii_qty { 5 }
        ii_price { 3000 }
      end

      before(:create) do |invoice, opt|
        items = create_list(:item, opt.item_count, merchant: opt.merchant)
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

    factory :invoice_with_unsuccessful_transaction do
      after(:create) do |invoice, options|
        create(:transaction, invoice: invoice)
      end
    end

    factory :invoice_with_transactions do
      transient do
        merchant { create(:merchant) }
        invoice_has_success { true }
        item_count { 2 }
        ii_qty { 5 }
        ii_price { 3000 }
        transaction_qty { 2 }
      end

     before(:create) do |invoice, opt|
        items = create_list(:item, opt.item_count, merchant: opt.merchant)
        items.each do |item|
          create(:invoice_item, invoice: invoice, item: item, quantity: opt.ii_qty, unit_price: opt.ii_price)
        end

        if opt.invoice_has_success
          create(:transaction, result: 1, invoice: invoice)
          create_list(:transaction, (opt.transaction_qty - 1), invoice: invoice)
        else
          create_list(:transaction, opt.transaction_qty, invoice: invoice)
        end
      end
    end
  end
end
