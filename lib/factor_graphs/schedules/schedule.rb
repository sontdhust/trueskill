module FactorGraphs
  module Schedules
    class Schedule

      def initialize(name = '')
        @name = name.empty? ? nil : 'Schedule(' + name + ')'
      end

      def visit(depth = -1, max_depth = 0)
        raise NotImplementedError, "Abstract method FactorGraphs::Schedule#visit(depth, max_depth)"
      end

      def to_s
        @name || super.to_s
      end
    end
  end
end
