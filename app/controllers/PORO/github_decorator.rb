class PORO::GithubDecorator
  def initialize(githubrepo)
    @git = githubrepo
  end

  def usernames
    @git.usernames.join(', ')
  end

  def commits
    hash_to_display(@git.collaborator_commits)
  end

  def pull_requests
    total_number(@git.pull_requests)
  end

  def repo_name
    @git.repo_name
  end

  private

  def hash_to_display(hash)
    hash.map do |key, value|
      "#{key}: #{value}"
    end.join(', ')
  end

  def total_number(hash)
    hash.values.sum
  end
end