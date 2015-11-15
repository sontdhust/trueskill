module FactorGraphs
  module Schedules
    class ScheduleStep < Schedule

      def initialize(factor, index, name = '')
        super(name)
        @factor = factor
        @index = index
      end

      def visit(depth = -1, max_depth = 0)
        @factor.update_message_at(@index)
      end
    end
  end
end
