class Merchants::ItemsController < ApplicationController
  layout 'dashboard'

  def index
    merchant
    @items = merchant.items
  end

  def show
    merchant
    item
  end

  def new
    @item = Item.new
  end

  def create
    item = merchant.items.new(merchant_item_params)
    if item.save(merchant_item_params)
      redirect_to merchant_items_path(merchant)
    else
      flash[:alert] = item.errors.full_messages.to_sentence
      redirect_to new_merchant_item_path(merchant)
    end
  end

  def edit
    merchant
    item
  end

  def update
    item
    if params[:status] != nil
      item.update!(update_params)
      redirect_to merchant_items_path(merchant)
    elsif item.update(merchant_item_params)
      flash[:alert] = "Item Information Successfully Updated"
      redirect_to merchant_item_path(merchant, item)
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to edit_merchant_item_path(merchant, item)
    end
  end

  private

  def merchant_item_params
    params.require(:item).permit(:name, :description, :unit_price, :status)
  end

  def update_params
    params.permit(:status)
  end

  def merchant
    @merchant ||= Merchant.find(params[:merchant_id])
  end

  def item
    @item ||= Item.find(params[:id])
  end
end