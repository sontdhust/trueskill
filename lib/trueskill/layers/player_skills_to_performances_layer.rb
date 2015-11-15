module Trueskill
  module Layers
    class PlayerSkillsToPerformancesLayer < TrueskillLayerBase

      def initialize(parent_factor_graph)
        super(parent_factor_graph)
      end

      def build_layer
        @input_variables_groups.each do |current_team|
          current_team_player_performances = []
          current_team.each do |player_skill_variable|
            player_performance = @parent_factor_graph.variable_factory.create_keyed_variable(player_skill_variable.key)
            @local_factors << Trueskill::Factors::GaussianLikelihoodFactor.new(
              @parent_factor_graph.game_info[:beta] ** 2, player_performance, player_skill_variable)
            current_team_player_performances << player_performance
          end
          @output_variables_groups << current_team_player_performances
        end
      end

      def create_prior_schedule
        FactorGraphs::Schedules::ScheduleSequence.new(@local_factors.map { |likelihood| FactorGraphs::Schedules::ScheduleStep.new(likelihood, 0) })
      end

      def create_posterior_schedule
        FactorGraphs::Schedules::ScheduleSequence.new(@local_factors.map { |likelihood| FactorGraphs::Schedules::ScheduleStep.new(likelihood, 1) })
      end
    end
  end
end
