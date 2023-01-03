FactoryBot.define do
  factory :invoice_item do
    association :item
    association :invoice
  end
end
