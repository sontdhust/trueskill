module FactorGraphs
  class VariableFactory

    def initialize(variable_prior_initializer)
      @variable_prior_initializer = variable_prior_initializer
    end

    def create_basic_variable(name = '')
      Variable.new(variable_prior_initializer.call, name)
    end

    def create_keyed_variable(key, name = '')
      KeyedVariable.new(key, variable_prior_initializer.call, name)
    end
  end
end
