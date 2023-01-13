class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  def discount_percentage
    ((1.00 - self.discount) * 100).to_i
  end
end
