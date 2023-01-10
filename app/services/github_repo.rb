class GithubRepo
  def initialize()
    @response = GithubService.new("/repos/pitzelalex/little-esty-shop").get_url
    @collabs = GithubService.new("/repos/pitzelalex/little-esty-shop/collaborators").get_url
    @commits = GithubService.new("/repos/pitzelalex/little-esty-shop/commits").get_url
    @contributors = GithubService.new("/repos/pitzelalex/little-esty-shop/contributors").get_url
    @pull_requests = GithubService.new("/repos/pitzelalex/little-esty-shop/pulls?state=all&per_page=100").get_url
    require 'pry'; binding.pry
  end

  def usernames
    @collabs.map{ |c| c[:login] }
  end

  def collab_commits
    commits = {}
    @contributors.each do |contributor|
      if usernames.include? contributor[:login]
        commits[contributor[:login].to_sym] = contributor[:contributions]
      end
    end
    commits
  end

  def pull_requests
    prs = {}
    @pull_requests.each do |pr|
      if usernames.include? pr[:user][:login]
        prs[pr[:user][:login].to_sym] ||= 0
        prs[pr[:user][:login].to_sym] += 1
      end
    end
    prs
  end

  def repo_name
    @_repo_name ||= @response[:name]
  end
end
