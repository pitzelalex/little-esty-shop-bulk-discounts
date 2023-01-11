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
    hash = {}
    @commits.each do |commit|
      if commit[:author].nil?
      else
        if usernames.include? commit[:author][:login]
          hash[commit[:author][:login].to_sym] ||= 0
          hash[commit[:author][:login].to_sym] += 1
        end
      end
    end
    hash
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
    @repo_name = @response[:name]
  end
end
