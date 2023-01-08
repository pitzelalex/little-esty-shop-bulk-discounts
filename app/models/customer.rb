class Customer < ApplicationRecord
  has_many :invoices 
  has_many :transactions, through: :invoices

  def self.top_5_customers 
    joins(invoices: :transactions)
    .where(transactions: {result: 1})
    .group(:id)
    .order("count(transactions) desc")
    .limit(5)
  end
end
