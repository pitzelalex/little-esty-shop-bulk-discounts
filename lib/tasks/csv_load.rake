require 'csv'

namespace :csv_load do
  desc "Loads the customers csv file into the db"
  task customers: :environment do
    csv = File.read('./db/data/customers.csv')
    CSV.parse(csv, headers: true).each do |row|
      Customer.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end

  desc "Loads the invoice_items csv file into the db"
  task invoice_items: [:invoices, :items] do
    csv = File.read('./db/data/invoice_items.csv')
    CSV.parse(csv, headers: true).each do |row|
      InvoiceItem.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  desc "Loads the invoices csv file into the db"
  task invoices: :customers do
    csv = File.read('./db/data/invoices.csv')
    CSV.parse(csv, headers: true).each do |row|
      Invoice.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  desc "Loads the items csv file into the db"
  task items: :merchants do
    csv = File.read('./db/data/items.csv')
    CSV.parse(csv, headers: true).each do |row|
      Item.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  desc "Loads the merchants csv file into the db"
  task merchants: :environment do
    csv = File.read('./db/data/merchants.csv')
    CSV.parse(csv, headers: true).each do |row|
      Merchant.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  end

  desc "Loads the transactions csv file into the db"
  task transactions: :invoices do
    csv = File.read('./db/data/transactions.csv')
    CSV.parse(csv, headers: true).each do |row|
      Transaction.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  desc "Loads all csv files into the db"
  task all: [:customers, :invoices, :merchants, :items, :transactions, :invoice_items] do
  end
end
