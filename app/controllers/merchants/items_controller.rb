class Merchants::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    # @top_items = @merchant.top_items
    @items = @merchant.items
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.new(merchant_item_params)
    if item.save(merchant_item_params)
      redirect_to merchant_items_path(merchant)
    else
      flash[:alert] = item.errors.full_messages.to_sentence
      redirect_to new_merchant_item_path(merchant)
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    if params[:status] != nil
      @item.update!(merchant_item_params)
      redirect_to merchant_items_path(@merchant)
    elsif @item.update(merchant_item_params)
      flash[:alert] = "Item Information Successfully Updated"
      redirect_to merchant_item_path(@merchant, @item)
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to edit_merchant_item_path(@merchant, @item)
    end
  end

  private
  #TODO: not all calls to merchant_item_params have (:item)
  def merchant_item_params
    params.require(:item).permit(:name, :description, :unit_price, :status)
  end
end