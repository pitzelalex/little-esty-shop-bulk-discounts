class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name 

  enum status: ['disabled', 'enabled']

  def top_customers
    self.customers.joins(:transactions).where(transactions: { result: 1 }).group('customers.id').order("count(transactions) desc").limit(5)
  end

  def self.enabled_merchants
    self.where(status: 'enabled')
  end

  def self.disabled_merchants
    self.where(status: 'disabled')
  end
end
