class AdminController < ApplicationController 
  
  def index 
    @top_5_customers = Customer.top_5_customers
    @incomplete_invoices = Invoice.incomplete_invoices
  end
end