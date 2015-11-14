module FactorGraphs
  class Variable

    attr_accessor :value

    def initialize(prior, name = '')
      @prior = prior
      @name = name.empty? ? nil : 'Variable(' + name + ')'
      reset_to_prior
    end

    def reset_to_prior
      @value = @prior
    end

    def to_s
      @name || super.to_s
    end
  end
end
