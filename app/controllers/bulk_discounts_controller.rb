class BulkDiscountsController < ApplicationController
  def create
    bd = BulkDiscount.create(bd_params)
  end

  private

  def bd_params
    require 'pry'; binding.pry
    
  end
end
