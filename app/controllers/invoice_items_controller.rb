class InvoiceItemsController < ApplicationController
  def update
    ii = InvoiceItem.find(params[:id])
    mer = ii.invoice.merchants.first
    inv = ii.invoice
    if ii.update(update_status)
      redirect_to merchant_invoice_path(mer, inv)
    else
      flash[:alert] = ii.errors.full_messages.to_sentence
      redirect_to merchant_invoice_path(mer, inv)
    end
  end

  private

  def update_status
    params.require(:invoice_item).permit(:status)
  end
end
