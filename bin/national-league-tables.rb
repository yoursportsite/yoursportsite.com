#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'yaml'

class Competition
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def url
    "https://multi-club-matches.football.web.gc.nationalleagueservices.co.uk/v2/league-tables/?competitionID=#{id}&seasonID=2025"
  end

  def slug
    name.downcase.gsub(" ", "-")
  end
end

competitions = [
  Competition.new(89, "National League"),
  Competition.new(372, "National League South"),
  Competition.new(373, "National League North")
]

competitions.each do |competition|
  uri = URI(competition.url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  path = "_data/football/competitions/#{competition.slug}.yml"
  File.open(path, "w") do |file|
    file.puts "---"
    file.puts "title: #{competition.name}"
    file.puts data.to_yaml.delete_prefix("---\n")
    file.puts "---"
  end
end

puts "Done."
