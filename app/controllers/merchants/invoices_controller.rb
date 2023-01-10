class Merchants::InvoicesController < ApplicationController
  layout 'dashboard'

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
    @items = @invoice.items
  end
end
