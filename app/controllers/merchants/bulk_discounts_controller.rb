class Merchants::BulkDiscountsController < ApplicationController
  def index
    merchant
    @discounts = merchant.bulk_discounts
    @holidays = HolidayDecorator.new('ca')
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new(merchant: merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  private

  def merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
