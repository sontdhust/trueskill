# -*- encoding : utf-8 -*-
module TrueSkillMatchers
  
  class EqualRating
    
    def initialize(mean, standard_deviation, precision)
      @expected = Trueskill::Rating.new(mean, standard_deviation)
      @precision = 10 ** precision
    end
    
    def matches?(target)
      @target = target
      @mean_diff = @expected.mean - @target.mean
      @standard_deviation_diff = @expected.standard_deviation - @target.standard_deviation
      (@mean_diff * @precision).to_i + (@standard_deviation_diff * @precision).to_i == 0
    end
    
    def failure_message
      "expected rating #{@target.to_s} to be equal to #{@expected.to_s} #{failure_info}"
    end
    
    def failure_message_when_negated
      "expected rating #{@target.to_s} not to be equal to #{@expected.to_s} #{failure_info}"
    end
    
    def failure_info
      msg = []
      msg << "mean differs by #{@mean_diff}" if @mean_diff != 0.0
      msg << "standard_deviation differs by #{@standard_deviation_diff}" if @standard_deviation_diff != 0.0
      " (#{msg.join(', ')})"
    end
    
  end
  
  def self.eql_rating(target_mean, target_standard_deviation, precision = 5)
    EqualRating.new(target_mean, target_standard_deviation, precision)
  end
  
end
