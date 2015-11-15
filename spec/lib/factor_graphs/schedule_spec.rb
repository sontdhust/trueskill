require File.expand_path('spec/spec_helper.rb')

describe FactorGraphs::Schedules::Schedule do

  before :each do
    @factor = Trueskill::Factors::GaussianPriorFactor.new(
      25.0,
      (25/3.0)**2,
      FactorGraphs::Variables::Variable.new(Numerics::GaussianDistribution.from_precision_mean(0.0, 0.0))
    )
    @step = FactorGraphs::Schedules::ScheduleStep.new(@factor, 0)
  end

  it "should do something" do
    @step.visit
  end
end
