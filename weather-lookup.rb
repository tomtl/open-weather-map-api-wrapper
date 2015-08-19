require "json"
require "faraday"
require "pry"

url = "http://api.openweathermap.org/data/2.5/weather"
location = ARGV.join
units = "imperial"

http_client = Faraday.new
response = http_client.get(url, q: location, units: units)
data = JSON.load(response.body)

temp = data["main"]["temp"]

puts temp

