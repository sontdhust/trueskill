class Team < ActiveRecord::Base

  attr_accessor :old_mean, :old_standard_deviation

  has_many :home_matches, foreign_key: 'home_id', class_name: 'Match'
  has_many :away_matches, foreign_key: 'away_id', class_name: 'Match'
end
