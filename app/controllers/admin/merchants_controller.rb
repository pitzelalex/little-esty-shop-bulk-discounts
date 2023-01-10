class Admin::MerchantsController < ApplicationController

  def index 
    @merchants = Merchant.all
  end

  def show
    merchant
  end

  def edit
    merchant
  end

  def update 
    if params[:status] != nil
      merchant.update!(merchant_params)
      redirect_to admin_merchants_path
    elsif merchant.update(merchant_params) 
      redirect_to admin_merchant_path(merchant)
      flash[:notice] = 'Merchant Information Successfully Updated'
    else
      flash[:alert] = 'Name field must not be empty. Please fill out and resubmit.'
      redirect_to edit_admin_merchant_path(merchant)
    end
  end

  def new 
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      redirect_to admin_merchants_path
    else 
      redirect_to new_admin_merchant_path 
      flash[:alert] = "Name field must not be empty. Please fill out and resubmit."
    end 
  end

  private

  def merchant_params
    params.permit(:name, :status)
  end

  def merchant
    @merchant ||= Merchant.find(params[:id])
  end
end