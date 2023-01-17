class Merchants::InvoicesController < ApplicationController

  # before_action :github, only: [:index]

  def index
    merchant
    @invoices = @merchant.invoices
    # @github = GithubDecorator.new(GithubRepo.new)
    @invoices = @merchant.invoices.indexed
  end

  def show
    merchant
    @invoice = Invoice.find(params[:id])
    @items = @invoice.items #needs a distinct
    @invoice_items = @invoice.invoice_items.order(quantity: :desc)
  end

  private

  def merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  # def github
  #   @github = GithubRepo.new
  # end
end
