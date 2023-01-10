FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant_#{n}" }
    status { 0 }
    
    trait :enabled do 
      status { 1 }
    end

    factory :enabled_merchant, traits: [:enabled]

    factory :merchant_with_items do
      transient do
        num { 4 }
      end

      before(:create) do |merchant, options|
        options.num.times do |t|
          create(:item, merchant: merchant)
        end
      end
    end

    factory :merchant_with_invoices do
      transient do
        invoice_num { 2 }
        item_num { 2 }
      end
  
      before(:create) do |merchant, options|
        options.invoice_num.times do 
          items = create_list(:item, options.item_num, merchant: merchant)
          invoice = create(:invoice)
          items.each do |item|
            create(:invoice_item, item: item, invoice: invoice)
          end
        end
      end
    end

    factory :merchant_with_dated_invoices do
      transient do
        invoice_num { 2 }
        date_offset { 1.month }
      end
  
      before(:create) do |merchant, options|
        item = create(:item, merchant: merchant)
        invoices = create_list(:invoice_with_successful_transaction, 3, :dated, date_offset: options.date_offset)
        invoices << create_list(:invoice_with_successful_transaction, 1, :dated, date_offset: 1.month)
        invoices << create_list(:invoice_with_unsuccessful_transaction, 2, :dated, date_offset: options.date_offset)
        invoices << create_list(:invoice_with_unsuccessful_transaction, 2, :dated, date_offset: 1.month)
        invoices.flatten.each_with_index do |invoice, index|
          create(:invoice_item, quantity: 5*(index + 1), unit_price: 10000, invoice: invoice, item: item)   
        end
      end
    end 
  end
end