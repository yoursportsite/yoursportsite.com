#!/usr/bin/env ruby
require 'json'
require 'net/http'
require 'time'
require 'yaml'
require_relative '../../lib/football'

competitions = [
  Football::Competition::national_league("National League", 89),
  Football::Competition::national_league("National League South", 372),
  Football::Competition::national_league("National League North", 373),
]

def normalize_result(result)
  case result
  when "W"
    "win"
  when "D"
    "draw"
  when "L"
    "loss"
  end
end

competitions.each do |competition|
  puts "Importing: #{competition.name}"

  # Get league table data
  league_table = competition.get_league_table

  # Parse league table data
  last_updated = Time.parse(league_table["meta"]["snapshotDate"]).iso8601
  standings = []
  for data in league_table["data"]
    standings << Football::Standing.new(
      data["attributes"]["position"],
      data["attributes"]["teamName"],
      data["attributes"]["played"],
      data["attributes"]["won"],
      data["attributes"]["lost"],
      data["attributes"]["drawn"],
      data["attributes"]["goalsFor"],
      data["attributes"]["goalsAgainst"],
      data["attributes"]["points"],
      data["attributes"]["form"].split(",").map(&method(:normalize_result)),
    )
  end

  # Write to file
  File.open(competition.path, "w") do |file|
    file.puts "---"
    file.puts "title: #{competition.name}"
    file.puts "slug: #{competition.slug}"
    file.puts "last_updated: #{last_updated}"
    file.puts "is_national_league: true"
    file.puts "standings:"
    file.puts standings.to_yaml.delete_prefix("---\n")
  end

  puts "Imported:  #{competition.name}"
end

puts "Done."
