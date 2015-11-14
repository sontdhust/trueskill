class StaticPagesController < ApplicationController
  def home
    @teams = Team.all
    @matches = Match.where(year: '1993-1994')
  end
end
