module FactorGraphs
  class Factor

    def initialize(name = '')
      @messages = []
      @message_to_variable_binding = {}
      @variables = []
      @name = name.empty? nil : 'Factor(' + name + ')'
    end

    def log_normalization
      return 0
    end

    def number_of_messages
      @messages.size
    end

    def update_message_at(message_index)
      update_message_with(@messages[message_index], @message_to_variable_binding[@messages[message_index]])
    end

    def update_message_with(message, variable)
      raise "Virtual method FactorGraphs::Factor#update_message_with(message, variable) not implemented"
    end

    def reset_marginals
      @message_to_variable_binding.values.each { |current_variable| current_variable.reset_to_prior }
    end

    def send_message_at(message_index)
      message = @messages[message_index]
      variable = @message_to_variable_binding[message]
      send_message_with(message, variable)
    end

    def send_message_with(message, variable)
      raise "Abstract method FactorGraphs::Factor#send_message_with(message, variable)"
    end

    def create_variable_to_message_binding(variable, message)
      @messages << message
      @message_to_variable_binding[message] = variable
      @variables << variable
      message
    end

    def to_s
      @name || super.to_s
    end
  end
end
