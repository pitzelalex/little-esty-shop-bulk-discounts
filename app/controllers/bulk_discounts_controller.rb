class BulkDiscountsController < ApplicationController
  def create
    BulkDiscount.create(bd_params)
    redirect_to merchant_bulk_discounts_path(bd_params[:merchant_id])
  end

  private

  def bd_params
    discount = 1.00 - (params[:bulk_discount][:discount].to_f / 100.0)
    hash = { merchant_id: params[:bulk_discount][:merchant_id],
             threshold: params[:bulk_discount][:threshold],
             discount: discount }
  end
end
