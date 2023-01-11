require 'httparty'
require 'json'

# https://api.github.com/repos/pitzelalex/little-esty-shop
class GithubService
  'https://api.githubt.com'

  def initialize(url)
    @url = url
  end

  # def github_data
  #   get_url
  # end

  def get_url
    response = HTTParty.get("https://api.github.com#{@url}",
                 headers: { 'User-Agent' => github_user_name,
                            'Authorization' => "token #{github_auth_token}" })
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def github_auth_token
    Rails.application.credentials.config[:github]
  end

  def github_user_name
    'pitzelalex'
  end
end
