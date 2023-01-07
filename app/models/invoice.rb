class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items

  enum status: ['in progress', 'completed', 'cancelled']

  def total_revenue
    self.invoice_items.sum('quantity*unit_price')
  end
end
