module FactorGraphs
  class Message

    attr_accessor :value

    def initialize(value, name = '')
      @value = value
      @name = name.empty? ? nil : 'Message(' + name + ')'
    end

    def to_s
      @name || super.to_s
    end
  end
end
