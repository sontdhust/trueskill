module FactorGraphs
  module Layers
    class Layer

      def build_layer
        raise NotImplementedError, "Abstract method FactorGraphs::Layer#build_layer"
      end

      def create_prior_schedule
        nil
      end

      def create_posterior_schedule
        nil
      end
    end
  end
end
