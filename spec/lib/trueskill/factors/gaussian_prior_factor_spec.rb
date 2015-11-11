require File.expand_path('spec/spec_helper.rb')

describe Trueskill::Factors::GaussianPriorFactor do

  before :each do
    @variable = FactorGraphs::Variable.new(Numerics::GaussianDistribution.new)
    @factor = Trueskill::Factors::GaussianPriorFactor.new(22.0, 0.3, @variable)
  end

  describe "#update_message_at" do

    it "should return a difference of 73.33333" do
      expect(@factor.update_message_at(0)).to be_within(tolerance).of(73.33333)
    end
  end

  describe "#log_normalization" do

    it "should be 0.0" do
      expect(@factor.log_normalization).to eq(0.0)
    end
  end
end
