FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item_#{n}" }
    sequence(:description) { |n| "Description_#{n}" }
    sequence(:unit_price) { |n| 10000 + (n * 1000) }
    association :merchant

    factory :item_with_invoice_item do
      transient do
        invoice { create(:invoice) }
      end

      before(:create) do |item, evaluator|
        create(:invoice_item, invoice: evaluator.invoice, item: item)
      end
    end
  end
end
