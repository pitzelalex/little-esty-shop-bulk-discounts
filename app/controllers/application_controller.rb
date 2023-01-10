class ApplicationController < ActionController::Base
  before_action :github
  helper_method :admin
    
  def github
    @github = GithubRepo.new
  end

  def admin
    false
  end
end
