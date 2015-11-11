module Trueskill
  module Layers
    class PlayerPerformancesToTeamPerformancesLayer < TrueskillLayerBase

      def initialize(parent_factor_graph)
        super(parent_factor_graph)
      end

      def build_layer
        @input_variables_groups.each do |current_team|
          team_performance = parent_factor_graph.variable_factory.create_basic_variable
          @local_factors << Trueskill::Factors::GaussianWeightedSumFactor.new(
            team_performance,
            current_team,
            current_team.map { |variable| variable.key.partial_play_percentage }
          )
          @output << [team_performance]
        end
      end

      def create_prior_schedule
        FactorGraphs::ScheduleSequence.new(
          @local_factors.map { |weighted_sum_factor| FactorGraphs::ScheduleStep.new(weighted_sum_factor, 0) })
      end
      
      def create_posterior_schedule
        schedules = []
        @local_factors.each do |current_factor|
          (1..(current_factor.number_of_messages - 1)).
            each { |current_iteration| schedules << FactorGraphs::ScheduleStep.new(current_factor, current_iteration) }
        end
        FactorGraphs::ScheduleSequence.new(schedules)
      end
      end
    end
  end
end
