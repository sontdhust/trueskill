module FactorGraphs
  class ScheduleLoop < Schedule

    def initialize(schedule_to_loop, max_delta, name = '')
      super(name)
      @schedule_to_loop = schedule_to_loop
      @max_delta = max_delta
    end

    def visit(depth = -1, max_depth = 0)
      total_iterations = 1
      delta = @schedule_to_loop.visit(depth + 1, max_depth)
      while delta > @max_delta
        delta = @schedule_to_loop.visit(depth + 1, max_depth)
        total_iterations += 1
      end
      delta
    end
  end
end
