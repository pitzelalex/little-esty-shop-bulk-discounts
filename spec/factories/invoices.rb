FactoryBot.define do
  factory :invoices do
    status { rand()}
    association :customer
  end
end
