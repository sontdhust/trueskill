module Trueskill
  module Factors
    class GaussianLikelihoodFactor < GaussianFactorBase

      def initialize(beta_squared, variable1, variable2)
        super()
        @precision = 1.0 / beta_squared
        create_variable_to_message_binding(variable1)
        create_variable_to_message_binding(variable2)
      end

      def log_normalization
        Numerics::GaussianDistribution.log_ratio_normalization(@variables[0].value, @messages[0].value)
      end

      def update_message_at(message_index)
        case message_index
        when 0 then update_helper(@messages[0], @messages[1], @variables[0], @variables[1])
        when 1 then update_helper(@messages[1], @messages[0], @variables[1], @variables[0])
        else
          raise ArgumentError, "Illegal message index: #{message_index}"
        end
      end

      private

      def update_helper(message1, message2, variable1, variable2)
        a = @precision / (@precision + variable2.value.precision - message2.value.precision)
        new_message = Numerics::GaussianDistribution.from_precision_mean(
          a * (variable2.value.precision_mean - message2.value.precision_mean),
          a * (variable2.value.precision - message2.value.precision)
        )
        new_marginal = (variable1.value / message1.value) * new_message
        diff = new_marginal - variable1.value
        message1.value = new_message
        variable1.value = new_marginal
        return diff
      end
    end
  end
end
