require 'json'
require 'net/http'

module Football
  class Competition
    attr_reader :name, :url, :slug, :path

    def initialize(name, url)
      @name = name
      @url = url
    end

    def self.national_league(name, competition_id)
      new(name, "https://multi-club-matches.football.web.gc.nationalleagueservices.co.uk/v2/league-tables/?competitionID=#{competition_id}&seasonID=2025")
    end

    def slug
      @name.downcase.gsub(" ", "-")
    end

    def path
      "_data/football/competitions/#{slug}.yml"
    end

    def get_league_table
      uri = URI(@url)
      response = Net::HTTP.get(uri)
      league_table = JSON.parse(response)
      league_table
    end
  end

  class Standing
    attr_reader :position, :team_name, :played, :won, :lost, :drawn, :goals_for, :goals_against, :goal_difference, :points, :form

    def initialize(position, team_name, played, won, lost, drawn, goals_for, goals_against, points, form)
      @position = position
      @team_name = team_name
      @played = played
      @won = won
      @lost = lost
      @drawn = drawn
      @goals_for = goals_for
      @goals_against = goals_against
      @points = points
      @form = form
    end

    def goal_difference
      return @goals_for - @goals_against
    end
  end
end
