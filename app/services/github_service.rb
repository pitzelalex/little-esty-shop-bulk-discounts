require 'httparty'
require 'json'

# https://api.github.com/repos/pitzelalex/little-esty-shop
class GithubService
  "https://api.githubt.com"

  def initialize(url)
    @url = "https://api.github.com" + url
  end

  def github_data
    get_url
  end

  def get_url
    response = HTTParty.get(@url)
    JSON.parse(response.body, symbolize_names: true)
  end
end