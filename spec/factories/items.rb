FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item_#{n}" }
    sequence(:description) { |n| "Description_#{n}" }
    sequence(:unit_price) { |n| 10000 + (n * 1000) }
    status { 0 }
    association :merchant

    trait :enabled do
      status { 1 }
     end

    factory :item_with_invoice_item do
      transient do
        invoice { create(:invoice) }
      end

      before(:create) do |item, evaluator|
        create(:invoice_item, invoice: evaluator.invoice, item: item)
      end
    end

    #TODO: consider adding price / qty if you want to do more granular testing
    #number_of_invoices is sufficient because it gives an item more sales instead of modifying price
    factory :item_with_successful_transaction do
      transient do
        number_of_invoices { 2 }
      end

      after(:create) do |item, options|
        invoices = create_list(:invoice_with_successful_transaction, options.number_of_invoices)   
        invoices.each do |invoice|
          create(:invoice_item, quantity: 5, unit_price: 10000, invoice: invoice, item: item)
        end
      end
    end

    factory :item_with_unsuccessful_transaction do
      transient do
        number_of_invoices { 2 }
      end

      after(:create) do |item, options|
        invoices = create_list(:invoice_with_unsuccessful_transaction, options.number_of_invoices)   
        invoices.each do |invoice|
          create(:invoice_item, quantity: 5, unit_price: 10000, invoice: invoice, item: item)
        end
      end
    end
    
    factory :item_with_dated_invoices do
      transient do
        date_offset { 1.month }
      end

      after(:create) do |item, options|
        invoices = create_list(:invoice_with_successful_transaction, 3, :dated, date_offset: options.date_offset)
        invoices2 = create_list(:invoice_with_successful_transaction, 2, :dated, date_offset: 1.month)
        invoices << invoices2
        invoices.flatten.each do |invoice|
          create(:invoice_item, quantity: 5, unit_price: 10000, invoice: invoice, item: item)
        end
      end
    end

    factory :packaged_item do
      transient do
        invoice { 'Requires Invoice as argument' }
      end

      after(:create) do |item, opt|
        create(:invoice_item, invoice: opt.invoice, item: item, status: 1)
      end
    end
  end
end
