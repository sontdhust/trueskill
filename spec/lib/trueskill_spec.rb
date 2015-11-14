require File.expand_path('spec/spec_helper.rb')

describe Trueskill do
  before :each do
    @player1 = Trueskill::Player.new('1')
    @player2 = Trueskill::Player.new('2')
  end

  describe "Test All Two Player Scenarios" do
    describe "Two Player" do
      context "Test" do
        let :team1 do
          { @player1 => Trueskill::Rating.new }
        end

        let :team2 do
          { @player2 => Trueskill::Rating.new }
        end

        it "Not Drawn" do
          rank = { team1 => 1, team2 => 2 }
          graph = Trueskill::TrueskillFactorGraph.new(rank)
          graph.update!
          expect(team1[@player1]).to TrueSkillMatchers::eql_rating(29.39583201999924, 7.171475587326186)
          expect(team2[@player2]).to TrueSkillMatchers::eql_rating(20.60416798000076, 7.171475587326186)
        end

        it "Drawn" do
          rank = { team1 => 1, team2 => 1 }
          graph = Trueskill::TrueskillFactorGraph.new(rank)
          graph.update!
          expect(team1[@player1]).to TrueSkillMatchers::eql_rating(25.0, 6.4575196623173081)
          expect(team2[@player2]).to TrueSkillMatchers::eql_rating(25.0, 6.4575196623173081)
        end
      end

      it "Chess Test Not Drawn" do
        team1 = { @player1 => Trueskill::Rating.new(1301.0007, 42.9232) }
        team2 = { @player2 => Trueskill::Rating.new(1188.7560, 42.5570) }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(
          rank, {
            :initial_mean => 1200.0,
            :initial_standard_deviation => 1200.0 / 3.0,
            :beta => 200.0,
            :dynamics_factor => 1200.0 / 300.0,
            :draw_probability => 0.03
          }
        )
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(1304.7820836053318, 42.843513887848658, 3)
        expect(team2[@player2]).to TrueSkillMatchers::eql_rating(1185.0383099003536, 42.485604606897752, 3)
      end
    end

    it "One On One Massive Upset Draw Test" do
      team1 = { @player1 => Trueskill::Rating.new }
      team2 = { @player2 => Trueskill::Rating.new(50, 12.5) }
      rank = { team1 => 1, team2 => 1 }
      graph = Trueskill::TrueskillFactorGraph.new(rank)
      graph.update!
      expect(team1[@player1]).to TrueSkillMatchers::eql_rating(31.662, 7.137, 3)
      expect(team2[@player2]).to TrueSkillMatchers::eql_rating(35.010, 7.910, 3)
    end
  end

  describe "Test All Two Team Scenarios" do
    before :each do
      @player3 = Trueskill::Player.new('3')
    end

    describe "One On Two" do
      it "Simple Test" do
        team1 = { @player1 => Trueskill::Rating.new }
        team2 = { @player2 => Trueskill::Rating.new, @player3 => Trueskill::Rating.new }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(33.730, 7.317, big_tolerance)
        expect(team2[@player2]).to TrueSkillMatchers::eql_rating(16.270, 7.317, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(16.270, 7.317, big_tolerance)
      end

      it "Somewhat Balanced" do
        team1 = { @player1 => Trueskill::Rating.new(40.0, 6.0) }
        team2 = { @player2 => Trueskill::Rating.new(20.0, 7.0), @player3 => Trueskill::Rating.new(25.0, 8.0) }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(42.744, 5.602, big_tolerance)
        expect(team2[@player2]).to TrueSkillMatchers::eql_rating(16.266, 6.359, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(20.123, 7.028, big_tolerance)
      end

      it "Draw Test" do
        team1 = { @player1 => Trueskill::Rating.new }
        team2 = { @player2 => Trueskill::Rating.new, @player3 => Trueskill::Rating.new }
        rank = { team1 => 1, team2 => 1 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(31.660, 7.138, big_tolerance)
        expect(team2[@player2]).to TrueSkillMatchers::eql_rating(18.340, 7.138, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(18.340, 7.138, big_tolerance)
      end
    end

    describe "One On Three" do
      before :each do
        @player4 = Trueskill::Player.new('4')
      end

      it "Simple Test" do
        team1 = { @player1 => Trueskill::Rating.new }
        team2 = { @player2 => Trueskill::Rating.new, @player3 => Trueskill::Rating.new, @player4 => Trueskill::Rating.new }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(36.337, 7.527, big_tolerance)
        expect(team2[@player2]).to TrueSkillMatchers::eql_rating(13.663, 7.527, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(13.663, 7.527, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(13.663, 7.527, big_tolerance)
      end

      it "Draw Test" do
        team1 = { @player1 => Trueskill::Rating.new }
        team2 = { @player2 => Trueskill::Rating.new, @player3 => Trueskill::Rating.new, @player4 => Trueskill::Rating.new }
        rank = { team1 => 1, team2 => 1 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(34.990, 7.455, big_tolerance)
        expect(team2[@player2]).to TrueSkillMatchers::eql_rating(15.010, 7.455, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(15.010, 7.455, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(15.010, 7.455, big_tolerance)
      end
    end

    describe "One On Seven" do
      it "Simple Test" do
        @player4 = Trueskill::Player.new('4')
        @player5 = Trueskill::Player.new('5')
        @player6 = Trueskill::Player.new('6')
        @player7 = Trueskill::Player.new('7')
        @player8 = Trueskill::Player.new('8')

        team1 = { @player1 => Trueskill::Rating.new }
        team2 = {
          @player2 => Trueskill::Rating.new,
          @player3 => Trueskill::Rating.new,
          @player4 => Trueskill::Rating.new,
          @player5 => Trueskill::Rating.new,
          @player6 => Trueskill::Rating.new,
          @player7 => Trueskill::Rating.new,
          @player8 => Trueskill::Rating.new
        }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(40.582, 7.917, big_tolerance)
        expect(team2[@player2]).to TrueSkillMatchers::eql_rating(9.418, 7.917, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(9.418, 7.917, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(9.418, 7.917, big_tolerance)
        expect(team2[@player5]).to TrueSkillMatchers::eql_rating(9.418, 7.917, big_tolerance)
        expect(team2[@player6]).to TrueSkillMatchers::eql_rating(9.418, 7.917, big_tolerance)
        expect(team2[@player7]).to TrueSkillMatchers::eql_rating(9.418, 7.917, big_tolerance)
        expect(team2[@player8]).to TrueSkillMatchers::eql_rating(9.418, 7.917, big_tolerance)
      end
    end

    describe "Two On Two" do
      before :each do
        @player4 = Trueskill::Player.new('4')
      end

      it "Simple Test" do
        team1 = { @player1 => Trueskill::Rating.new, @player2 => Trueskill::Rating.new }
        team2 = { @player3 => Trueskill::Rating.new, @player4 => Trueskill::Rating.new }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(28.108, 7.774, big_tolerance)
        expect(team1[@player2]).to TrueSkillMatchers::eql_rating(28.108, 7.774, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(21.892, 7.774, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(21.892, 7.774, big_tolerance)
      end

      it "Draw Test" do
        team1 = { @player1 => Trueskill::Rating.new, @player2 => Trueskill::Rating.new }
        team2 = { @player3 => Trueskill::Rating.new, @player4 => Trueskill::Rating.new }
        rank = { team1 => 1, team2 => 1 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(25, 7.455, big_tolerance)
        expect(team1[@player2]).to TrueSkillMatchers::eql_rating(25, 7.455, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(25, 7.455, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(25, 7.455, big_tolerance)
      end

      it "Unbalance Draw Test" do
        team1 = { @player1 => Trueskill::Rating.new(15.0, 8.0), @player2 => Trueskill::Rating.new(20.0, 6.0) }
        team2 = { @player3 => Trueskill::Rating.new(25.0, 4.0), @player4 => Trueskill::Rating.new(30.0, 3.0) }
        rank = { team1 => 1, team2 => 1 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(21.570, 6.556, big_tolerance)
        expect(team1[@player2]).to TrueSkillMatchers::eql_rating(23.696, 5.418, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(23.357, 3.833, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(29.075, 2.931, big_tolerance)
      end

      it "Upset Test" do
        team1 = { @player1 => Trueskill::Rating.new(20, 8), @player2 => Trueskill::Rating.new(25, 6) }
        team2 = { @player3 => Trueskill::Rating.new(35, 7), @player4 => Trueskill::Rating.new(40, 5) }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(29.698, 7.008, big_tolerance)
        expect(team1[@player2]).to TrueSkillMatchers::eql_rating(30.455, 5.594, big_tolerance)
        expect(team2[@player3]).to TrueSkillMatchers::eql_rating(27.575, 6.346, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(36.211, 4.768, big_tolerance)
      end
    end

    describe "Three On Two" do
      it "Tests" do
        @player4 = Trueskill::Player.new('4')
        @player5 = Trueskill::Player.new('5')
        @player6 = Trueskill::Player.new('6')

        team1 = {
          @player1 => Trueskill::Rating.new(28.0, 7.0),
          @player2 => Trueskill::Rating.new(27.0, 6.0),
          @player3 => Trueskill::Rating.new(26.0, 5.0)
        }
        team2 = {
          @player4 => Trueskill::Rating.new(30.0, 4.0),
          @player5 => Trueskill::Rating.new(31.0, 3.0)
        }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(28.658, 6.770, big_tolerance)
        expect(team1[@player2]).to TrueSkillMatchers::eql_rating(27.484, 5.856, big_tolerance)
        expect(team1[@player3]).to TrueSkillMatchers::eql_rating(26.336, 4.917, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(29.785, 3.958, big_tolerance)
        expect(team2[@player5]).to TrueSkillMatchers::eql_rating(30.879, 2.983, big_tolerance)

        @player4 = Trueskill::Player.new('4')
        @player5 = Trueskill::Player.new('5')
        @player6 = Trueskill::Player.new('6')

        team1 = {
          @player1 => Trueskill::Rating.new(28.0, 7.0),
          @player2 => Trueskill::Rating.new(27.0, 6.0),
          @player3 => Trueskill::Rating.new(26.0, 5.0)
        }
        team2 = {
          @player4 => Trueskill::Rating.new(30.0, 4.0),
          @player5 => Trueskill::Rating.new(31.0, 3.0)
        }
        rank = { team1 => 2, team2 => 1 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(21.840, 6.314, big_tolerance)
        expect(team1[@player2]).to TrueSkillMatchers::eql_rating(22.474, 5.575, big_tolerance)
        expect(team1[@player3]).to TrueSkillMatchers::eql_rating(22.857, 4.757, big_tolerance)
        expect(team2[@player4]).to TrueSkillMatchers::eql_rating(32.012, 3.877, big_tolerance)
        expect(team2[@player5]).to TrueSkillMatchers::eql_rating(32.132, 2.949, big_tolerance)        
      end
    end

    describe "Four On Four" do
      before :each do
        @player4 = Trueskill::Player.new('4')
        @player5 = Trueskill::Player.new('5')
        @player6 = Trueskill::Player.new('6')
        @player7 = Trueskill::Player.new('7')
        @player8 = Trueskill::Player.new('8')
      end

      it "Simple Test" do
        team1 = {
          @player1 => Trueskill::Rating.new,
          @player2 => Trueskill::Rating.new,
          @player3 => Trueskill::Rating.new,
          @player4 => Trueskill::Rating.new
        }
        team2 = {
          @player5 => Trueskill::Rating.new,
          @player6 => Trueskill::Rating.new,
          @player7 => Trueskill::Rating.new,
          @player8 => Trueskill::Rating.new
        }
        rank = { team1 => 1, team2 => 2 }
        graph = Trueskill::TrueskillFactorGraph.new(rank)
        graph.update!
        expect(team1[@player1]).to TrueSkillMatchers::eql_rating(27.198, 8.059, big_tolerance)
        expect(team1[@player2]).to TrueSkillMatchers::eql_rating(27.198, 8.059, big_tolerance)
        expect(team1[@player3]).to TrueSkillMatchers::eql_rating(27.198, 8.059, big_tolerance)
        expect(team1[@player4]).to TrueSkillMatchers::eql_rating(27.198, 8.059, big_tolerance)
        expect(team2[@player5]).to TrueSkillMatchers::eql_rating(22.802, 8.059, big_tolerance)
        expect(team2[@player6]).to TrueSkillMatchers::eql_rating(22.802, 8.059, big_tolerance)
        expect(team2[@player7]).to TrueSkillMatchers::eql_rating(22.802, 8.059, big_tolerance)
        expect(team2[@player8]).to TrueSkillMatchers::eql_rating(22.802, 8.059, big_tolerance)
      end
    end
  end
end
