class Match < ActiveRecord::Base

  attr_accessor :predict

  belongs_to :home, foreign_key: 'home_id', class_name: 'Team'
  belongs_to :away, foreign_key: 'away_id', class_name: 'Team'
end
