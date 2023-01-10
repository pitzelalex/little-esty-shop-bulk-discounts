class Customer < ApplicationRecord
  has_many :invoices 
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices
  has_many :items, through: :invoices

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.top_5_customers 
    joins(invoices: :transactions)
    .where(transactions: {result: 1})
    .group(:id)
    .select("customers.*, count(distinct transactions) as num_transactions")
    .order(num_transactions: :desc)
    .limit(5)
  end
end
