require "spec_helper"
require_relative "../weather_lookup"

RSpec.describe "weather_lookup" do
  it "gets the current temperature", :vcr do
    result = get_temp("Boston")
    expect(result).to eq(82.74)
  end
  
  it "handles invalid location", :vcr do
    expect(->{
      get_temp("")
    }).to raise_error(LocationNotFound, /Not found city/)
  end
  
  it "handles an exception from Faraday" do
    stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?q=Boston&units=imperial").to_timeout

    expect(->{
      get_temp("Boston")
    }).to raise_error(RequestFailed, /execution expired/)
  end
end