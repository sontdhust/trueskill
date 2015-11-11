module Trueskill
  module Factors
    class GaussianWeightedSumFactor < GaussianFactorBase

      def initialize(sum_variable, variables_to_sum, variable_weights)
        super()
        @weights = [variable_weights]
        @weights_squared = [@weights.first.map { |w| w ** 2 }]
        @variable_index_orders_for_weights = [(0..(variables_to_sum.size + 1)).to_a]
        (1..(variable_weights.size)).each do |weights_index|
          current_weights = []
          @weights[weights_index] = current_weights
          variable_indices = []
          variable_indices[0] = weights_index
          current_weights_squared = []
          @weights_squared[weights_index] = current_weights_squared
          current_destination_weight_index = 0
          (0..(variable_weights.size - 1)).each do |current_weight_source_index|
            next if current_weight_source_index == weights_index - 1
            current_weight = variable_weights[weights_index - 1] == 0 ?
              0.0 :
              -variable_weights[current_weight_source_index] / variable_weights[weights_index - 1]
            current_weights[current_destination_weight_index] = current_weight
            current_weights_squared[current_destination_weight_index] = current_weight ** 2
            variable_indices[current_destination_weight_index + 1] = current_weight_source_index + 1
            current_destination_weight_index += 1
          end
          final_weight = variable_weights[weights_index - 1] == 0 ? 0.0 : 1.0 / variable_weights[weights_index - 1]
          current_weights[current_destination_weight_index] = final_weight
          current_weights_squared[current_destination_weight_index] = final_weight ** 2
          variable_indices[variable_weights.size] = 0
          @variable_index_orders_for_weights << variable_indices
        end
        create_variable_to_message_binding(sum_variable)
        variables_to_sum.each { |current_variable| create_variable_to_message_binding(current_variable) }
      end

      def log_normalization
        result = 0.0
        (1..(@variables.size - 1)).each do |i|
          result += Numerics::GaussianDistribution.log_ratio_normalization(@variables[i].value, @messages[i].value)
        end
        result
      end

      def update_message_at(message_index)
        raise ArgumentError, "Illegal message message_index: #{message_index}" if message_index < 0 || message_index >= @messages.size
        updated_messages = []
        updated_variables = []
        indices_to_use = @variable_index_orders_for_weights[message_index]
        @messages.each_index do |i|
          updated_messages << @messages[indices_to_use[i]]
          updated_variables << @variables[indices_to_use[i]]
        end
        update_helper(@weights[message_index], @weights_squared[message_index], updated_messages, updated_variables)
      end

      private

      def update_helper(weights, weights_squared, messages, variables)
        marginal0 = variables[0].value.clone
        inverse_of_new_precision_sum, weighted_mean_sum = 0.0, 0.0
        weights_squared.each_index do |i|
          inverse_of_new_precision_sum += weights_squared[i] / (variables[i + 1].value.precision - messages[i + 1].value.precision)
          diff = variables[i + 1].value / messages[i + 1].value
          weighted_mean_sum +=
            weights[i] *
            (variables[i + 1].value.precision_mean - messages[i + 1].value.precision_mean) /
            (variables[i + 1].value.precision - messages[i + 1].value.precision)
        end
        new_message = Numerics::GaussianDistribution.from_precision_mean(
          1.0 / inverse_of_new_precision_sum * weighted_mean_sum,
          1.0 / inverse_of_new_precision_sum
        )
        old_marginal_without_message = marginal0 / messages[0].value.clone
        new_marginal = old_marginal_without_message * new_message
        messages[0].value = new_message.clone
        variables[0].value = new_marginal.clone
        return new_marginal - marginal0
      end
    end
  end
end
