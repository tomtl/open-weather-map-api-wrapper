require "json"
require "faraday"
require "pry"

class LocationNotFound < StandardError; end
class RequestFailed < StandardError; end

def get_temp(location)
  url = "http://api.openweathermap.org/data/2.5/weather"
  units = "imperial"
  
  http_client = Faraday.new
  response = http_client.get(url, q: location, units: units)
  data = JSON.load(response.body)

  raise LocationNotFound.new(data["message"]) unless data["main"]
  data["main"]["temp"] if data
rescue Faraday::Error => e
  raise RequestFailed, e.message, e.backtrace
end

if $0 == __FILE__
  location = ARGV.join
  puts get_temp(location) 
end

