class GithubRepo
  def initialize()
    @response = GithubService.new("/repos/pitzelalex/little-esty-shop").get_url
    @collabs = GithubService.new("/repos/pitzelalex/little-esty-shop/collaborators").get_url
    @commits = []
    @contributors = GithubService.new("/repos/pitzelalex/little-esty-shop/contributors").get_url
    @pull_requests = GithubService.new("/repos/pitzelalex/little-esty-shop/pulls?state=all&per_page=100").get_url

    get_commits
  end


  def get_commits
    loop.with_index do |_, index|
      fetched = GithubService.new("/repos/pitzelalex/little-esty-shop/commits?per_page=100&page=#{index + 1}").get_url
      @commits << fetched
      if fetched.count < 100
        @commits.flatten!
        break
      end
    end
  end

  def usernames
    @collabs.map{ |c| c[:login] }
  end

  def collaborator_commits
    @commits.map do |commit| 
      commit.dig(:author, :login) if usernames.include?(commit.dig(:author, :login)) 
    end.compact.tally
  end

  def pull_requests
    @pull_requests.map do |pr| 
      pr.dig(:user, :login) if usernames.include?(pr.dig(:user, :login)) 
    end.compact.tally
  end

  def repo_name
    @repo_name = @response[:name]
  end
end
