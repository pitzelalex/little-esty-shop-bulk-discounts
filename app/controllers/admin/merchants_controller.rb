class Admin::MerchantsController < ApplicationController

  def index 
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update 
    @merchant = Merchant.find(params[:id])
    if params[:name].empty?
      redirect_to edit_admin_merchant_path(@merchant)
      flash[:alert] = 'Name field must not be empty. Please fill out and resubmit.'
    else
      @merchant.update(merchant_params)
      redirect_to admin_merchant_path(@merchant)
      flash[:notice] = 'Merchant Information Successfully Updated'
    end
  end

  private
  def merchant_params
    params.permit(:name)
  end
end