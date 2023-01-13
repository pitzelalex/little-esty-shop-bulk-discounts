class Merchants::BulkDiscountsController < ApplicationController
  def index
    merchant
    @discounts = merchant.bulk_discounts
  end

  def new
    @bulk_discount = BulkDiscount.new(merchant: merchant)
  end

  private

  def merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
