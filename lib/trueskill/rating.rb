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

    def win_probability(other, beta = 25.0 / 6.0)
      mean_diff = @mean - other.mean
      denom = Math.sqrt(2 * (beta ** 2) + standard_deviation ** 2 + other.standard_deviation ** 2)
      Numerics::GaussianDistribution.cdf(mean_diff / denom)
    end

    def to_s
      "[μ=#{'%.4f' % mean}, σ=#{'%.4f' % standard_deviation}]"
    end
  end
end
