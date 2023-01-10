class Transaction < ApplicationRecord
  belongs_to :invoice
  delegate :customer, to: :invoice
  enum result: ['failed', 'success']
end
