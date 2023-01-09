class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name 

  enum status: ['disabled', 'enabled']

  def top_customers
    self.invoices.joins(:customer, :transactions).where(transactions: { result: 1 }).select('customers.*').group('customers.id').order("count(transactions) desc").limit(5)
  end

  def customer_amount_of_successful_transactions(cus_id)
    self.invoices.where(customer_id: cus_id).joins(:transactions).where(transactions: { result: 1 }).distinct.count
  end

  def top_items
    self.items.joins(:invoices).merge(Invoice.has_successful_transaction).select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').group('items.name', :id).order(revenue: :desc).limit(5)
  end

  def self.enabled_merchants
    self.where(status: 'enabled')
  end

  def self.disabled_merchants
    self.where(status: 'disabled')
  end

  def self.top_five_merchants 
    joins(:invoices, :transactions)
    .where(transactions: {result: 1})
    .group(:id)
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_rev")
    .order(total_rev: :desc).limit(5)
  end

  def best_day 
    self.invoices.joins(:transactions)
    .where(transactions: {result: 1})
    .select('invoices.created_at', 'sum(invoice_items.quantity * invoice_items.unit_price) as total_day_revenue')
    .group(:created_at).order(total_day_revenue: :desc).first.created_at
  end
end
