require 'httparty'
require 'json'

# https://api.github.com/repos/pitzelalex/little-esty-shop
class GithubService
  'https://api.githubt.com'

  def initialize(url)
    @url = url
  end

  def github_data
    get_url
  end

  def get_url
    # response = HTTParty.get(@url)
    response = HTTParty.get("https://api.github.com#{@url}",
                 headers: { 'User-Agent' => github_user_name,
                            'Authorization' => "token #{github_auth_token}" })
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def github_auth_token
    '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'
  end

  def github_user_name
    'pitzelalex'
  end
end
