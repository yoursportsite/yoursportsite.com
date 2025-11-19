#!/usr/bin/env ruby
require 'json'
require 'net/http'
require 'time'
require 'yaml'
require_relative '../../lib/football'

competitions = [
  Football::Competition.new("Premier League", "https://webapi.gc.avfcservices.co.uk/v1/league-tables/opta?competitionID=8"),
  Football::Competition.new("Championship", "https://league-tables.football.web.gc.coventrycityfcservices.co.uk/v1/opta?competitionID=10"),
  Football::Competition.new("League One", "https://league-tables.football.web.gc.stockportcountyfcservices.co.uk/v1/opta?competitionID=11"),
  Football::Competition.new("League Two", "https://league-tables.football.web.gc.swindontownfcservices.co.uk/v1/opta?competitionID=12"),
]

competitions.each do |competition|
  puts "Importing: #{competition.name}"

  # Get league table data
  league_table = competition.get_league_table

  # Parse league table data
  last_updated = Time.parse(league_table["body"]["importUTCDateTime"]).iso8601
  standings = []
  for data in league_table["body"]["leagueTable"]["teamStandings"]
    standings << Football::Standing.new(
      data["position"],
      data["teamName"],
      data["played"],
      data["won"],
      data["lost"],
      data["drawn"],
      data["goalsFor"],
      data["goalsAgainst"],
      data["points"],
      data["form"],
    )
  end

  # Write to file
  File.open(competition.path, "w") do |file|
    file.puts "---"
    file.puts "title: #{competition.name}"
    file.puts "slug: #{competition.slug}"
    file.puts "last_updated: #{league_table["body"]["importUTCDateTime"]}"
    file.puts "standings:"
    file.puts standings.to_yaml.delete_prefix("---\n")
  end

  puts "Imported:  #{competition.name}"
end

puts "Done."
