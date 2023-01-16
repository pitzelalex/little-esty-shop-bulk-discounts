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

  def discounted_revenue_for(merchant)
    # merchant.invoice_items.where(invoice_id: id).sum('quantity*invoice_items.unit_price')
    merchant.invoice_items.where(invoice_id: id).sum { |ii| ii.discounted_revenue }
  end

  def discounted_revenue
    self.invoice_items.sum { |ii| ii.discounted_revenue }
  end

  def self.incomplete_invoices
    self.joins(:invoice_items).where.not(invoice_items: { status: 2 }).order(:created_at).distinct
  end
end
