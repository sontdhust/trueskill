module Trueskill
  module Layers
    class IteratedTeamDifferencesInnerLayer < TrueskillLayerBase

      def initialize(parent_factor_graph, team_performances_to_performance_differences, team_differences_comparison_layer)
        super(parent_factor_graph)
        @team_performances_to_team_performance_differences_layer = team_performances_to_performance_differences
        @team_differences_comparison_layer = team_differences_comparison_layer
      end

      def build_layer
        @team_performances_to_team_performance_differences_layer.input_variables_groups = @input_variables_groups
        @team_performances_to_team_performance_differences_layer.build_layer
        @team_differences_comparison_layer.input_variables_groups =
          @team_performances_to_team_performance_differences_layer.output_variables_groups
        @team_differences_comparison_layer.build_layer
      end

      def create_prior_schedule
        loop_schedule = if @input_variables_groups.size == 2
          create_two_team_inner_prior_loop_schedule
        elsif @input_variables_groups.size > 2
          create_multiple_team_inner_prior_loop_schedule
        else
          raise RuntimeError, 'Illegal input variables group'
        end
        total_team_differences = @team_performances_to_team_performance_differences_layer.local_factors.size;
        FactorGraphs::Schedules::ScheduleSequence.new([
          loop_schedule, 
          FactorGraphs::Schedules::ScheduleStep.new(@team_performances_to_team_performance_differences_layer.local_factors[0], 1),
          FactorGraphs::Schedules::ScheduleStep.new(@team_performances_to_team_performance_differences_layer.
            local_factors[total_team_differences - 1], 2)
        ])
      end

      def local_factors
        @team_performances_to_team_performance_differences_layer.local_factors +
          @team_differences_comparison_layer.local_factors
      end

      private

      def create_two_team_inner_prior_loop_schedule
        FactorGraphs::Schedules::ScheduleSequence.new([
          FactorGraphs::Schedules::ScheduleStep.new(@team_performances_to_team_performance_differences_layer.local_factors[0], 0), 
          FactorGraphs::Schedules::ScheduleStep.new(@team_differences_comparison_layer.local_factors[0], 0)
        ])
      end

      def create_multiple_team_inner_prior_loop_schedule
        total_team_differences = @team_performances_to_team_performance_differences_layer.local_factors.size
        forward_schedule = FactorGraphs::Schedules::ScheduleSequence.new(
          (0..(total_team_differences - 2)).map { |i|
            FactorGraphs::Schedules::ScheduleSequence.new([
              FactorGraphs::Schedules::ScheduleStep.new(@team_performances_to_team_performance_differences_layer.local_factors[i], 0),
              FactorGraphs::Schedules::ScheduleStep.new(@team_differences_comparison_layer.local_factors[i], 0),
              FactorGraphs::Schedules::ScheduleStep.new(@team_performances_to_team_performance_differences_layer.local_factors[i], 2)
            ])
          }
        )
        backward_schedule = FactorGraphs::Schedules::ScheduleSequence.new(
          (0..(total_team_differences - 2)).map { |i|
            FactorGraphs::Schedules::ScheduleSequence.new([
              FactorGraphs::Schedules::ScheduleStep.new(
                @team_performances_to_team_performance_differences_layer.local_factors[total_team_differences - 1 - i], 0),
              FactorGraphs::Schedules::ScheduleStep.new(
                @team_differences_comparison_layer.local_factors[total_team_differences - 1 - i], 0),
              FactorGraphs::Schedules::ScheduleStep.new(
                @team_performances_to_team_performance_differences_layer.local_factors[total_team_differences - 1 - i], 1)
            ])
          }
        )
        FactorGraphs::Schedules::ScheduleLoop.new(FactorGraphs::Schedules::ScheduleSequence.new([forward_schedule, backward_schedule]), 0.0001)
      end
    end
  end
end
