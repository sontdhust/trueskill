module FactorGraphs
  class KeyedVariable < Variable

    attr_reader :key

    def initialize(key, prior, name = '')
      super(prior, name)
      @key = key
      @prior = prior
    end
  end
end
