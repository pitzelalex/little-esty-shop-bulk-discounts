class ApplicationController < ActionController::Base
  before_action :github

  def github
    @github = GithubRepo.new
  end
end
