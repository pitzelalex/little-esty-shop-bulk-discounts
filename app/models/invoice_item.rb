class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  enum status: ['pending', 'packaged', 'shipped']

  def revenue
    cents = unit_price * quantity
    # helper.number_to_currency(cents / 100.0)
  end
end
