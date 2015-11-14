module FactorGraphs
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
end
