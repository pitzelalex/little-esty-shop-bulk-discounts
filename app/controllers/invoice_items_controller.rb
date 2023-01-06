class InvoiceItemsController < ApplicationController
  def update
    ii = InvoiceItem.find(update_status[:id])
    ii.update(status: update_status[:status])
    mer = ii.invoice.merchants.first
    inv = ii.invoice
    redirect_to merchant_invoice_path(mer, inv)
  end

  private

  def update_status
    update = params.require(:invoice_item).permit(:status)
    id = params.permit(:id)
    update.merge(id)
  end
end
