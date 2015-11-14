class Match < ActiveRecord::Base

  belongs_to :home, foreign_key: 'home_id', class_name: 'Team'
  belongs_to :away, foreign_key: 'away_id', class_name: 'Team'
end
