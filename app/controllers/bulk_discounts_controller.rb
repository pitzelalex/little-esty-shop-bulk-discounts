class BulkDiscountsController < ApplicationController
  def create
    bd = BulkDiscount.new(bd_params)

    if bd.save
      redirect_to merchant_bulk_discounts_path(bd_merchant[:merchant_id])
    else
      flash[:alert] = bd.errors.full_messages.to_sentence
      redirect_to new_merchant_bulk_discount_path(bd_merchant[:merchant_id])
    end
  end

  def update
    bd = BulkDiscount.find(params[:id])

    if bd.update(bd_params)
      redirect_to merchant_bulk_discount_path(bd_merchant[:merchant_id], bd)
    else
      flash[:alert] = bd.errors.full_messages.to_sentence
      redirect_to edit_merchant_bulk_discount_path(bd_merchant[:merchant_id], bd)
    end
  end

  def destroy
    bd = BulkDiscount.find(params[:id])
    bd.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private

  def bd_params
    discount = 1.00 - (params[:bulk_discount][:discount].to_f / 100.0)
    hash = { merchant_id: params[:bulk_discount][:merchant_id],
             threshold: params[:bulk_discount][:threshold],
             discount: discount }
  end

  def bd_merchant
    params.require(:bulk_discount).permit(:merchant_id)
  end
end
