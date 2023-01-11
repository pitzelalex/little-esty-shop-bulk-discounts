class ApplicationController < ActionController::Base
  helper_method :admin
    
  def github
  end


  def admin
    false
  end
end
