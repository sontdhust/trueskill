module Trueskill
  module Factors
    class GaussianWithinFactor < GaussianFactorBase

      def initialize(epsilon, variable)
        super()
        @epsilon = epsilon
        create_variable_to_message_binding(variable) 
      end

      def log_normalization
        message_from_variable = @variables[0].value / @messages[0].value
        mean = message_from_variable.mean
        standard_deviation = message_from_variable.standard_deviation
        z =
          Numerics::GaussianDistribution.cdf((@epsilon - mean) / standard_deviation) -
          Numerics::GaussianDistribution.cdf((-@epsilon - mean) / standard_deviation)
        -Numerics::GaussianDistribution.log_product_normalization(message_from_variable, @messages[0].value) + Math.log(z)
       end

      def update_message_with(message, variable)
        message_from_variable = variable.value / message.value
        c = message_from_variable.precision
        d = message_from_variable.precision_mean
        sqrt_c = Math.sqrt(c)
        d_on_sqrt_c = d / sqrt_c
        epsilon_times_sqrt_c = @epsilon * sqrt_c
        denominator = 1.0 - Numerics::TruncatedGaussianCorrectionFunctions.w_within_margin(d_on_sqrt_c, epsilon_times_sqrt_c)
        new_precision = c / denominator
        new_precision_mean = 
          (d + sqrt_c * Numerics::TruncatedGaussianCorrectionFunctions.v_within_margin(d_on_sqrt_c, epsilon_times_sqrt_c)) /
          denominator
        new_marginal = Numerics::GaussianDistribution.from_precision_mean(new_precision_mean, new_precision)
        new_message = message.value * new_marginal / variable.value
        diff = new_marginal - variable.value
        message.value = new_message
        variable.value = new_marginal
        return diff
      end
    end
  end
end
