module FactorGraphs
  module Layers
    class FactorGraphLayer < Layer

      attr_writer :input_variables_groups
      attr_reader :local_factors, :output_variables_groups

      def initialize(parent_factor_graph)
        @parent_factor_graph = parent_factor_graph
        @local_factors = []
        @output_variables_groups = []
        @input_variables_groups = []
      end
    end
  end
end
