class Merchants::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.indexed
  end

  def show
    @invoice = Invoice.find(params[:id])
    @items = @invoice.items
  end
end
