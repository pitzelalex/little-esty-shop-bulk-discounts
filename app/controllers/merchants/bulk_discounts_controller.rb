class Merchants::BulkDiscountsController < ApplicationController
  def index
    merchant
    @discounts = merchant.bulk_discounts
  end

  def new
    @bulk_discount = BulkDiscount.new(merchant: merchant)
  end

  def create
    bd = BulkDiscount.create(bd_params)
  end

  private

  def merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def bd_params
    require 'pry'; binding.pry
    
  end
end
