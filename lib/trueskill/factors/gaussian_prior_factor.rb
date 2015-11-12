module Trueskill
  module Factors
    class GaussianPriorFactor < GaussianFactorBase

      def initialize(mean, variance, variable)
        super()
        @new_message = Numerics::GaussianDistribution.new(mean, Math.sqrt(variance))
        create_variable_to_message_binding(variable)
      end

      def update_message_with(message, variable)
        new_marginal = Numerics::GaussianDistribution.from_precision_mean(
          variable.value.precision_mean + @new_message.precision_mean - message.value.precision_mean,
          variable.value.precision + @new_message.precision - message.value.precision
        )
        diff = variable.value - new_marginal
        variable.value = new_marginal
        message.value = @new_message
        return diff
      end
    end
  end
end
