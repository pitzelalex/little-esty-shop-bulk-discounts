class Customer < ApplicationRecord
  has_many :invoices 
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
