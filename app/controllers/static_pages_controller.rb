class StaticPagesController < ApplicationController
  def home
    @teams = Team.all
  end

  def load_data
    @matches = Match.where(year: year_params)
    for match in @matches
      win_probability = Trueskill::Rating.new(match.home.mean, match.home.standard_deviation).
        win_probability(Trueskill::Rating.new(match.away.mean, match.away.standard_deviation))
      if win_probability < 1.0 / 3.0
        match.predict = 'H'
      elsif win_probability > 2.0 / 3.0
        match.predict = 'A'
      else
        match.predict = 'D'
      end
    end
  end

  def calculate_season
    @matches = Match.where(year: year_params)
    @teams = Team.all
    for team in @teams
      team.old_mean = team.mean
      team.old_standard_deviation = team.standard_deviation
    end
    for match in @matches
      home_player = Trueskill::Player.new(match.home.name)
      away_player = Trueskill::Player.new(match.away.name)
      home_team = {
        home_player => Trueskill::Rating.new(match.home.mean, match.home.standard_deviation)
      }
      away_team = {
        away_player => Trueskill::Rating.new(match.away.mean, match.away.standard_deviation)
      }
      case match.result
      when 'H'
        rank = { home_team => 1, away_team => 2 }
      when 'A'
        rank = { away_team => 1, home_team => 2 }
      else
        rank = { home_team => 1, away_team => 1 }
      end
      graph = Trueskill::TrueskillFactorGraph.new(rank)
      result = graph.update
      @teams.find{ |t| t.id == match.home_id }.mean = result[home_player].mean
      @teams.find{ |t| t.id == match.home_id }.standard_deviation =
        result[home_player].standard_deviation
      @teams.find{ |t| t.id == match.away_id }.mean = result[away_player].mean
      @teams.find{ |t| t.id == match.away_id }.standard_deviation =
        result[away_player].standard_deviation
    end
    Team.transaction do
      @teams.each(&:save!)
    end
  end

  def reset
    @teams = Team.all
    for team in @teams
      team.update_attributes(mean: 25.0, standard_deviation: 25.0 / 3.0)
    end
  end

  def year_params
    params.require(:current_year)
  end
end
