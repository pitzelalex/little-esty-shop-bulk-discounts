require 'httparty'
require 'json'

class HolidayService
  def initialize(code)
    @response = HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/#{code}")
  end

  def parsed
    JSON.parse(@response.body, symbolize_names: true)
  end
end
