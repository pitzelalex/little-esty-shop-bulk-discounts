class GithubRepo
  def initialize()
    @response = GithubService.new("/repos/pitzelalex/little-esty-shop").get_url
  end

  def repo_name
    @_repo_name ||= @response[:name]
  end
end