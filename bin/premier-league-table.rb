#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'yaml'

uri = URI("https://webapi.gc.avfcservices.co.uk/v1/league-tables/opta?competitionID=8")
response = Net::HTTP.get(uri)
data = JSON.parse(response)
path = "_data/football/competitions/premier-league.yml"

File.open(path, "w") do |file|
  file.puts "---"
  file.puts "title: Premier League"
  file.puts data.to_yaml.delete_prefix("---\n")
  file.puts "---"
end

puts "Done."
