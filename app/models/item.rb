class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices

  def invoice_item_by_invoice(invoice)
    self.invoice_items.where(invoice_id: invoice.id).first
  end
end
