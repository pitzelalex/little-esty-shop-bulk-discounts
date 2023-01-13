class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :threshold, numericality: { only_integer: true }
  validates :discount, numericality: { less_than_or_equal_to: 1.0, greater_than_or_equal_to: 0, message: 'must be a number between 0 and 100' }

  def discount_percentage
    ((1.00 - self.discount) * 100).to_i
  end
end
