class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name 

  enum status: ['disabled', 'enabled']
  
  def top_customers
  end
end
