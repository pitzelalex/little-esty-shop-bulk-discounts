class ApplicationController < ActionController::Base
  helper_method :admin
    
  def admin
    false
  end
end
