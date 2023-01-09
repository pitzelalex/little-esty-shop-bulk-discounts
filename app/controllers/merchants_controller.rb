class MerchantsController < ApplicationController
  layout 'dashboard' 
  
  def show
    @merchant = Merchant.find(params[:id])
  end
end