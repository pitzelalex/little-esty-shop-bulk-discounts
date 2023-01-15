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

  def discounted_revenue
    merchant = Merchant.first
    require 'pry'; binding.pry
    BulkDiscount.joins(:invoice_items).where(invoice_items: { invoice_id: self.id }).where("invoice_items.quantity >= ?", 20)
    BulkDiscount.joins(:invoice_items).where("invoice_items.quantity >= ?", 20)
    BulkDiscount.select('bulk_discounts.*, invoice_items.*').joins(:invoice_items).where(invoice_items: { invoice_id: self.id })
    merchant.invoice_items.joins(:bulk_discounts)
  end

  def self.incomplete_invoices
    self.joins(:invoice_items).where.not(invoice_items: { status: 2 }).order(:created_at).distinct
  end
end
