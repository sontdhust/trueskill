require File.expand_path('spec/spec_helper.rb')

describe Trueskill::Factors::GaussianLikelihoodFactor do

  before :each do
    @variable1 = FactorGraphs::Variables::Variable.new(Numerics::GaussianDistribution.new(26, 1.1))
    @variable2 = FactorGraphs::Variables::Variable.new(Numerics::GaussianDistribution.from_precision_mean(0.0, 0.0))
    @factor = Trueskill::Factors::GaussianLikelihoodFactor.new(30, @variable1, @variable2)
  end

  describe "#update_message_at" do

    it "should return a difference of 0.0" do
      expect(@factor.update_message_at(0)).to be_within(tolerance).of(0.0)
    end

    it "should return a difference of 0.833066 for the second message" do
      @factor.update_message_at(0)
      expect(@factor.update_message_at(1)).to be_within(tolerance).of(0.833066)
    end
  end

  describe "#log_normalization" do

    it "should be 0.0" do
      expect(@factor.log_normalization).to eq(0.0)
    end
  end
end
