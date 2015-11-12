# -*- encoding : utf-8 -*-
require 'rubygems'
require 'rspec'

require 'pp'

%w(
  gaussian_distribution
  truncated_gaussian_correction_functions
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "numerics", "#{name}.rb"))
end

%w(
  factor
  factor_graph
  layer
  message
  schedule
  variable
  variable_factory
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "factor_graphs", "#{name}.rb"))
end

%w(
  gaussian_factor_base
  gaussian_greater_than_factor
  gaussian_likelihood_factor
  gaussian_prior_factor
  gaussian_weighted_sum_factor
  gaussian_within_factor
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "trueskill", "factors", "#{name}.rb"))
end

%w(
  trueskill_layer_base
  iterated_team_differences_inner_layer
  player_performances_to_team_performances_layer
  player_prior_values_to_skills_layer
  player_skills_to_performances_layer
  team_differences_comparison_layer
  team_performances_to_team_performance_differences_layer
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "trueskill", "layers", "#{name}.rb"))
end

%w(
  player
  rating
  trueskill_factor_graph
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "trueskill", "#{name}.rb"))
end

require File.expand_path(File.join(File.dirname(__FILE__), "trueskill_matchers.rb"))

def tolerance
  0.001
end

def create_teams
  @team1 = { Trueskill::Player.new => Trueskill::Rating.new(25, 4.1) }
  @team2 = { Trueskill::Player.new => Trueskill::Rating.new(27, 3.1), Trueskill::Player.new => Trueskill::Rating.new(10, 1.0) }
  @team3 = { Trueskill::Player.new => Trueskill::Rating.new(32, 0.2) }
  [@team1, @team2, @team3]
end
