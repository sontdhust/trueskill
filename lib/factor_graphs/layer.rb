module FactorGraphs
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
