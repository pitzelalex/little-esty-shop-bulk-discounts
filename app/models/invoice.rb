class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items

  enum status: ['in progress', 'completed', 'cancelled']

  scope :has_successful_transaction, -> { joins(:transactions).where(transactions: {result: 'success'})}

  scope :indexed, -> { distinct.order(:id) }

  def total_revenue
    self.invoice_items.sum('quantity*unit_price')
  end

  def discount_value
    Proc.new { |x| x.invoice_discount }
  end

  def discounted_revenue_for(merchant)
    merchant.invoice_items.where(invoice_id: id).select('invoice_items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total').group(:id).sum("?", &discount_value)
  end

  def discounted_revenue
    self.invoice_items.where(invoice_id: id).select('invoice_items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total').group(:id).sum("?", &discount_value)
  end

  def self.incomplete_invoices
    self.joins(:invoice_items).where.not(invoice_items: { status: 2 }).order(:created_at).distinct
  end
end
