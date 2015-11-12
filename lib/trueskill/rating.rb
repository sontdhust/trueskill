module Trueskill
  class Rating
    attr_reader :mean, :standard_deviation

    def initialize(mean = 25.0, standard_deviation = 25.0 / 3.0)
      @mean = mean
      @standard_deviation = standard_deviation
    end

    def replace(other)
      @mean = other.mean
      @standard_deviation = other.standard_deviation
    end
  end
end
