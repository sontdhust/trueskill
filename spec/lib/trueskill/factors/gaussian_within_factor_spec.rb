require File.expand_path('spec/spec_helper.rb')

describe Trueskill::Factors::GaussianWithinFactor do

  before :each do
    @variable = FactorGraphs::Variable.new(Numerics::GaussianDistribution.new(1.0, 1.1))
    @factor = Trueskill::Factors::GaussianWithinFactor.new(0.01, @variable)
  end

  describe "#update_message_at" do

    it "should return a difference of 173.2048" do
      expect(@factor.update_message_at(0)).to be_within(tolerance).of(173.2048)
    end
  end

  describe "#log_normalization" do

    it "should be -5.339497" do
      expect(@factor.log_normalization).to be_within(tolerance).of(-5.339497)
    end
  end
end
