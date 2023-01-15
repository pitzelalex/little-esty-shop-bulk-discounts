class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants
  validates_presence_of :status
  enum status: ['pending', 'packaged', 'shipped']

  def revenue
    InvoiceItem.where(id: self.id).sum('quantity*unit_price')
  end

  def discounted_revenue
    if self.bulk_discounts.where('threshold <= ?', self.quantity).count == 0
      revenue
    else
      discount = self.bulk_discounts.where('threshold <= ?', self.quantity).order(threshold: :desc).first.discount
      revenue * discount
    end
  end
end
