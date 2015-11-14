module Numerics
  class GaussianDistribution

    # Constant helpers
    @@sqrt2 = Math.sqrt(2).freeze
    @@inv_sqrt_2pi = (1 / Math.sqrt(2 * Math::PI)).freeze
    @@log_sqrt_2pi = Math.log(Math.sqrt(2 * Math::PI)).freeze

    # mean (average): μ (mu)
    # standard_deviation: σ (sigma)
    # variance: σ ** 2
    # precision: π (pi) = 1.0 / variance = 1.0 / (σ ** 2)
    # precision_mean: τ (tau) = precision * mean = μ / (σ ** 2)
    attr_reader :mean, :standard_deviation, :variance, :precision, :precision_mean

    def initialize(mean = 0.0, standard_deviation = 1.0)
      @mean = mean
      @standard_deviation = standard_deviation
      @variance = standard_deviation ** 2
      @precision = !standard_deviation.to_f.finite? ? 0.0 : 1.0 / @variance.to_f
      @precision_mean = !mean.to_f.finite? ? 0.0 : @precision * mean
    end

    class << self

      def from_precision_mean(precision_mean, precision)
        GaussianDistribution.new(precision_mean / precision, Math.sqrt(1 / precision))
      end

      def absolute_difference(left, right)
        [(left.precision_mean - right.precision_mean).abs, Math.sqrt((left.precision - right.precision).abs)].max
      end

      def log_product_normalization(left, right)
        return 0.0 if left.precision == 0.0 || right.precision == 0.0
        variance_sum = left.variance + right.variance
        mean_difference = left.mean - right.mean
        -@@log_sqrt_2pi - (Math.log(variance_sum) / 2.0) - (mean_difference ** 2 / (2.0 * variance_sum))
      end

      def log_ratio_normalization(numerator, denominator)
        return 0.0 if numerator.precision == 0.0 || denominator.precision == 0.0
        variance_difference = denominator.variance - numerator.variance
        mean_difference = numerator.mean - denominator.mean
        Math.log(denominator.variance) + @@log_sqrt_2pi - (Math.log(variance_difference) / 2.0) +
          (mean_difference ** 2 / (2.0 * variance_difference))
      end

      def cumulative_distribution_function(x)
        0.5 * error_function(x / -@@sqrt2)
      end
      alias_method :cdf, :cumulative_distribution_function

      def error_function(x)
        Math.erfc(x)
      end

      # Quantile function
      def inverse_distribution_function(x, mean = 0.0, standard_deviation = 1.0)
        mean - @@sqrt2 * standard_deviation * inverse_error_function(2.0 * x)
      end
      alias_method :inv_cdf, :inverse_distribution_function

      def inverse_error_function(p)
        return -100 if p >= 2.0
        return 100 if p <= 0.0

        pp = p < 1.0 ? p : 2.0 - p
        t = Math.sqrt(-2 * Math.log(pp / 2.0)) # Initial guess
        x = -0.70711 * ((2.30753 + t * 0.27061) / (1.0 + t * (0.99229 + t * 0.04481)) - t)

        [0,1].each do |j|
          err = error_function(x) - pp
          x += err / (1.12837916709551257 * Math.exp(-(x * x)) - x * err) # Halley
        end
        p < 1.0 ? x : -x
      end

      def probability_density_function(x)
        @@inv_sqrt_2pi * Math.exp(-0.5 * (x ** 2))
      end
      alias_method :pdf, :probability_density_function

      def standard
        @@standard ||= GaussianDistribution.new
      end
    end

    def at(x)
      #                1              -(x-mean)^2 / (2*stdDev^2)
      # P(x) = ------------------- * e
      #        stdDev * sqrt(2*pi)
      exp = -(x - @mean) ** 2 / (2.0 * @variance)
      (1.0 / @standard_deviation) * @@inv_sqrt_2pi * Math.exp(exp)
    end

    def *(other)
      GaussianDistribution.from_precision_mean(self.precision_mean + other.precision_mean, self.precision + other.precision)
    end

    def /(other)
      GaussianDistribution.from_precision_mean(self.precision_mean - other.precision_mean, self.precision - other.precision)
    end

    def -(other)
      GaussianDistribution.absolute_difference(self, other)
    end

    def +(other)

    end

    def ==(other)
      self.mean == other.mean && self.variance == other.variance
    end

    def equals(other)
      self == other
    end

    def to_s
      "[μ=#{'%.4f' % mean}, σ=#{'%.4f' % standard_deviation}]"
    end
  end
end
