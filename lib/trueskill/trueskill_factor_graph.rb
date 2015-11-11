module Trueskill
  class TrueskillFactorGraph < FactorGraphs::FactorGraph

    attr_reader :game_info

    def initialize(teams_ranks_hash, game_info = {})
      @teams = teams_ranks_hash.keys
      @ranks = teams_ranks_hash.values

      @game_info = {
        :beta => 25.0 / 6.0,                          # β
        :draw_probability => 0.1,
        :dynamics_factor => 25.0 / 300.0,             # τ
        :initial_mean => 25.0,                        # μ
        :initial_standard_deviation => 25.0 / 3.0     # σ
      }.merge(game_info)
      @variable_factory = FactorGraphs::VariableFactory.new(-> { Numerics::GaussianDistribution.from_precision_mean })

      @prior_layer = Trueskill::Layers::PlayerPriorValuesToSkillsLayer.new(self, @teams)
      @layers = [
        @prior_layer,
        Trueskill::Layers::PlayerSkillsToPerformancesLayer.new(self),
        Trueskill::Layers::PlayerPerformancesToTeamPerformancesLayer.new(self),
        Trueskill::Layers::IteratedTeamDifferencesInnerLayer.new(
          self,
          Trueskill::Layers::TeamPerformancesToTeamPerformanceDifferencesLayer.new(self),
          Trueskill::Layers::TeamDifferencesComparisonLayer.new(self, @ranks)
        )
      ]
    end

    def build_graph
      last_output = nil
      @layers.each do |current_layer|
        current_layer.input_variables_groups = last_output if last_output != nil
        current_layer.build_layer
        last_output = current_layer.output_variables_groups
      end
    end

    def run_schedule
      schedules = @layers.map(&:create_prior_schedule) + @layers.reverse.map(&:create_posterior_schedule)
      FactorGraphs::ScheduleSequence.new(schedules.compact).visit
    end

    def get_updated_ratings
      result = {}
      @prior_layer.output_variables_groups.each do |current_team|
        current_team.each do |current_player|
          result[current_layer.key] = Rating.new(current_player.value.mean, current_player.value.standard_deviation)
        end
      end
      result
    end
  end
end
