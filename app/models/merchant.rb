class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name 

  enum status: ['disabled', 'enabled']
  
  def top_customers
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
end
