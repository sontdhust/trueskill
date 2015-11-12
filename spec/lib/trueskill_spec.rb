require File.expand_path('spec/spec_helper.rb')

describe Trueskill do
  context "Test All Two Player Scenarios" do
    it "Two Player Test Not Drawn" do
      player1 = Trueskill::Player.new('1')
      player2 = Trueskill::Player.new('2')
      team1 = { player1 => Trueskill::Rating.new }
      team2 = { player2 => Trueskill::Rating.new }
      match = { team1 => 1, team2 => 2 }
      graph = Trueskill::TrueskillFactorGraph.new(match)
      graph.update

      expect(team1[player1].mean).to be_within(tolerance).of(29.39583201999924)
      expect(team1[player1].standard_deviation).to be_within(tolerance).of(7.171475587326186)
      expect(team2[player2].mean).to be_within(tolerance).of(20.60416798000076)
      expect(team2[player2].standard_deviation).to be_within(tolerance).of(7.171475587326186)
    end

    it "Two Player Test Drawn" do
      player1 = Trueskill::Player.new('1')
      player2 = Trueskill::Player.new('2')
      team1 = { player1 => Trueskill::Rating.new }
      team2 = { player2 => Trueskill::Rating.new }
      match = { team1 => 1, team2 => 1 }
      graph = Trueskill::TrueskillFactorGraph.new(match)
      graph.update

      expect(team1[player1].mean).to be_within(tolerance).of(25.0)
      expect(team1[player1].standard_deviation).to be_within(tolerance).of(6.4575196623173081)
      expect(team2[player2].mean).to be_within(tolerance).of(25.0)
      expect(team2[player2].standard_deviation).to be_within(tolerance).of(6.4575196623173081)
    end

    it "Two Player Chess Test Not Drawn" do
      player1 = Trueskill::Player.new('1')
      player2 = Trueskill::Player.new('2')
      team1 = { player1 => Trueskill::Rating.new(1301.0007, 42.9232) }
      team2 = { player2 => Trueskill::Rating.new(1188.7560, 42.5570) }
      match = { team1 => 1, team2 => 2 }
      graph = Trueskill::TrueskillFactorGraph.new(
        match, {
          :initial_mean => 1200.0,
          :initial_standard_deviation => 1200.0 / 3.0,
          :beta => 200.0,
          :dynamics_factor => 1200.0 / 300.0,
          :draw_probability => 0.03
        }
      )
      graph.update

      expect(team1[player1].mean).to be_within(tolerance).of(1304.7820836053318)
      expect(team1[player1].standard_deviation).to be_within(tolerance).of(42.843513887848658)
      expect(team2[player2].mean).to be_within(tolerance).of(1185.0383099003536)
      expect(team2[player2].standard_deviation).to be_within(tolerance).of(42.485604606897752)
    end

    it "One On One Massive Upset Draw Test" do
      player1 = Trueskill::Player.new('1')
      player2 = Trueskill::Player.new('2')
      team1 = { player1 => Trueskill::Rating.new }
      team2 = { player2 => Trueskill::Rating.new(50, 12.5) }
      match = { team1 => 1, team2 => 1 }
      graph = Trueskill::TrueskillFactorGraph.new(match)
      graph.update

      expect(team1[player1].mean).to be_within(tolerance).of(31.662)
      expect(team1[player1].standard_deviation).to be_within(tolerance).of(7.137)
      expect(team2[player2].mean).to be_within(tolerance).of(35.010)
      expect(team2[player2].standard_deviation).to be_within(tolerance).of(7.910)
    end
  end
end
