class StaticPagesController < ApplicationController
  def home
    @teams = Team.all
    @matches = Match.all
  end
end
