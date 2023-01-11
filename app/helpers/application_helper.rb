module ApplicationHelper
  class GithubDecorator
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
      hash_to_display(@git.pull_requests)
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
  end
end
