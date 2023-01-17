class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants
  validates_presence_of :status
  enum status: ['pending', 'packaged', 'shipped']

  def bulk_discount
    bd = self.bulk_discounts.where('threshold <= ?', self.quantity).order(threshold: :desc).first
  end

  def discount
    self.bulk_discounts.where('threshold <= ?', self.quantity).order(threshold: :desc).first.try(:discount)
  end

  def invoice_discount
    if discount.nil?
      return 1 * self.total
    else
      return discount * self.total
    end
  end
end
