module FactorGraphs
  class Schedule

    def initialize(name = '')
      @name = name.empty? nil : 'Schedule(' + name + ')'
    end

    def visit(depth = -1, max_depth = 0)
      raise "Abstract method FactorGraphs::Schedule#visit(depth, max_depth)"
    end

    def to_s
      @name || super.to_s
    end
  end

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

  class ScheduleSequence < Schedule

    def initialize(schedules, name = '')
      super(name)
      @schedules = schedules
    end

    def visit(depth = -1, max_depth = 0)
      max_delta = 0
      @schedules.each do |current_schedule|
        max_delta = [current_schedule.visit(depth + 1, max_depth), max_delta].max
      end
      max_delta
    end
  end

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
