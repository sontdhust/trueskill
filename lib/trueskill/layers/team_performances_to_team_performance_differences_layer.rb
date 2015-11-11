module Trueskill
  module Layers
    class TeamPerformancesToTeamPerformanceDifferencesLayer < TrueskillLayerBase

      def initialize(parent_factor_graph)
        super(parent_factor_graph)
      end

      def build
        (0..(@input_variables_groups.size - 2)).each do |i|
          current_difference = @parent_factor_graph.variable_factory.create_basic_variable
          @factors << Trueskill::Factors::GaussianWeightedSumFactor.new(
            current_difference, [@input_variables_groups[i][0], @input_variables_groups[i + 1][0]], [1.0, -1.0])
          @output_variables_groups << [current_difference]
        end
      end
    end
  end
end
