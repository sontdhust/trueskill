module Trueskill
  module Layers
    class TrueskillLayerBase < FactorGraphs::Layers::FactorGraphLayer

      def initialize(parent_factor_graph)
        super(parent_factor_graph)
      end
    end
  end
end
