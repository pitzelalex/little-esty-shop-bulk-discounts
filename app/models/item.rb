class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices

  enum status: [:disabled, :enabled]

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def invoice_item_by_invoice(invoice)
    self.invoice_items.where(invoice_id: invoice.id).first
  end
  
  def date_with_most_sales
    self.invoices.merge(Invoice.has_successful_transaction).select('invoices.*', 'count(invoices.created_at) as number_of_sales').group(:id, :created_at).order(:number_of_sales).first.created_at
  end
end
