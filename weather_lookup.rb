require "json"
require "faraday"
require "pry"

class LocationNotFound < StandardError; end
class RequestFailed < StandardError; end

class OpenWeatherMapClient 
  def initialize(http_client = Faraday.new)
    @http_client = http_client
  end
  
  def current_temperature(location)
    url = "http://api.openweathermap.org/data/2.5/weather"
    units = "imperial"
    data = make_request(url, q: location, units: units)

    raise LocationNotFound.new(data["message"]) unless data["main"]
    data["main"]["temp"]
  end
  
  private
  
  def make_request(url, params={})
    response = @http_client.get(url, params)
    JSON.load(response.body)
  rescue Faraday::Error => e
    raise RequestFailed, e.message, e.backtrace
  end
end

def get_temp(location)
  openweathermap_client = OpenWeatherMapClient.new
  openweathermap_client.current_temperature(location)
end

if $0 == __FILE__
  location = ARGV.join
  puts get_temp(location) 
end

