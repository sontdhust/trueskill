module Trueskill
  module Factors
    class GaussianFactorBase < FactorGraphs::Factor

      def initialize(name = '')
        super(name)
      end

      def send_message_with(message, variable)
        marginal = variable.value
        message_value = message.value
        log_z = Numerics::GaussianDistribution.log_product_normalization(marginal, message_value)
        variable.value = marginal * message_value
        return log_z
      end

      def create_variable_to_message_binding(variable)
        super(variable, FactorGraphs::Message.new(Numerics::GaussianDistribution.new))
      end
    end
  end
end
