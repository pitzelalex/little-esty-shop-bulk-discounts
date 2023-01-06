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
    if params[:status] != nil
      @merchant.update!(merchant_params)
      redirect_to admin_merchants_path
    elsif @merchant.update(merchant_params) 
      redirect_to admin_merchant_path(@merchant)
      flash[:notice] = 'Merchant Information Successfully Updated'
    else
      flash[:alert] = 'Name field must not be empty. Please fill out and resubmit.'
      redirect_to edit_admin_merchant_path(@merchant)
    end
  end

  def new 
  end

  def create
    @merchant = Merchant.create!(merchant_params)
    redirect_to admin_merchants_path
  end

  private
  def merchant_params
    params.permit(:name, :status)
  end
end