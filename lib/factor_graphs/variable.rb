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

  class DefaultVariable < Variable

  end

  class KeyedVariable < Variable

    attr_reader :key

    def initialize(key, prior, name = '')
      super(prior, name)
      @key = key
      @prior = prior
    end
  end
end
