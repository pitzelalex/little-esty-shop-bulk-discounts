class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  validates :status, inclusion: { in: ['pending', 'packaged', 'shipped'], message: 'is not valid'}
  enum status: ['pending', 'packaged', 'shipped']

  def revenue
    InvoiceItem.where(id: self.id).sum('quantity*unit_price')
    # cents = unit_price * quantity
    # helper.number_to_currency(cents / 100.0)
  end
end
