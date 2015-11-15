class StaticPagesController < ApplicationController
  def home
    @teams = Team.all
    session[:current_year] = 1992 unless session.key?(:current_year)
    session[:calculated] = true unless session.key?(:calculated)
    load
  end

  def load_data
    return if session[:current_year] == 2015
    session[:current_year] += 1
    session[:calculated] = false
    load
  end

  def calculate_season
    return if session[:current_year] > 2015
    @matches = Match.where(
      year: session[:current_year].to_s + '-' + (session[:current_year] + 1).to_s)
    @teams = Team.all
    for team in @teams
      team.old_mean = team.mean
      team.old_standard_deviation = team.standard_deviation
    end
    for match in @matches
      home = @teams.find{ |t| t.id == match.home_id }
      away = @teams.find{ |t| t.id == match.away_id }
      home_player = Trueskill::Player.new(match.home.name)
      away_player = Trueskill::Player.new(match.away.name)
      home_team = { home_player => Trueskill::Rating.new(home.mean, home.standard_deviation) }
      away_team = { away_player => Trueskill::Rating.new(away.mean, away.standard_deviation) }
      case match.result
      when 'H'
        rank = { home_team => 1, away_team => 2 }
      when 'A'
        rank = { away_team => 1, home_team => 2 }
      else
        rank = { home_team => 1, away_team => 1 }
      end
      graph = Trueskill::TrueskillFactorGraph.new(rank)
      new_rating = graph.update

      home.mean = new_rating[home_player].mean
      home.standard_deviation = new_rating[home_player].standard_deviation
      away.mean = new_rating[away_player].mean
      away.standard_deviation = new_rating[away_player].standard_deviation
    end
    Team.transaction do
      @teams.each(&:save!)
    end
    session[:calculated] = true
  end

  def predict_match
    if params[:home] == 'null' || params[:away] == 'null'
      @predict = 'Please select teams'
      return
    end
    home = Team.find(params[:home])
    away = Team.find(params[:away])
    win_probability = Trueskill::Rating.new(home.mean, home.standard_deviation).
      win_probability(Trueskill::Rating.new(away.mean, away.standard_deviation))
    puts win_probability
    if win_probability > 0.45
      @predict = 'Predict: Home team win'
    elsif win_probability < 0.35
      @predict = 'Predict: Away team win'
    else
      @predict = 'Predict: Draw'
    end
  end

  def calculate_match
    return if params[:home] == 'null' || params[:away] == 'null' || params[:result] == 'undefined' ||
      params[:home] == params[:away]
    home = Team.find(params[:home])
    away = Team.find(params[:away])
    home.old_mean = home.mean
    home.old_standard_deviation = home.standard_deviation
    away.old_mean = away.mean
    away.old_standard_deviation = away.standard_deviation
    home_player = Trueskill::Player.new(home.name)
    away_player = Trueskill::Player.new(away.name)
    home_team = { home_player => Trueskill::Rating.new(home.mean, home.standard_deviation) }
    away_team = { away_player => Trueskill::Rating.new(away.mean, away.standard_deviation) }
    case params[:result]
    when 'H'
      rank = { home_team => 1, away_team => 2 }
    when 'A'
      rank = { away_team => 1, home_team => 2 }
    else
      rank = { home_team => 1, away_team => 1 }
    end
    graph = Trueskill::TrueskillFactorGraph.new(rank)
    new_rating = graph.update
    home.update_attributes(
      mean: new_rating[home_player].mean,
      standard_deviation: new_rating[home_player].standard_deviation
    )
    away.update_attributes(
      mean: new_rating[away_player].mean,
      standard_deviation: new_rating[away_player].standard_deviation
    )
    @teams = Team.all
    @teams.find{ |t| t.id == home.id }.old_mean = home.old_mean
    @teams.find{ |t| t.id == home.id }.old_standard_deviation = home.old_standard_deviation
    @teams.find{ |t| t.id == away.id }.old_mean = away.old_mean
    @teams.find{ |t| t.id == away.id }.old_standard_deviation = away.old_standard_deviation
  end

  def reset
    session[:current_year] = 1992
    session[:calculated] = true
    @teams = Team.all
    for team in @teams
      team.mean = 25.0
      team.standard_deviation = 25.0 / 3.0
    end
    Team.transaction do
      @teams.each(&:save!)
    end
  end

  private

  def load
    @matches = Match.where(
      year: session[:current_year].to_s + '-' + (session[:current_year] + 1).to_s)
    prediction_count = 0
    for match in @matches
      win_probability = Trueskill::Rating.new(match.home.mean, match.home.standard_deviation).
        win_probability(Trueskill::Rating.new(match.away.mean, match.away.standard_deviation))
        # TODO: Choose relevant value
      if win_probability > 0.45
        match.predict = 'H'
      elsif win_probability < 0.35
        match.predict = 'A'
      else
        match.predict = 'D'
      end
      prediction_count += 1 if match.result == match.predict
    end
    @correct_prediction = @matches.size > 0 ?
      "Correct prediction: %0.02f %%" % [prediction_count.to_f / @matches.size.to_f * 100] :
      ''
  end
end
