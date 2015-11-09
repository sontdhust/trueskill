# -*- encoding : utf-8 -*-
require File.expand_path('spec/spec_helper.rb')

describe Numerics::TruncatedGaussianCorrectionFunctions do

  describe "#w_within_margin" do

    it "should return 0.970397 for (0.2, 0.3)" do
      expect(Numerics::TruncatedGaussianCorrectionFunctions.w_within_margin(0.2, 0.3)).to be_within(tolerance).of(0.970397)
      expect(Numerics::TruncatedGaussianCorrectionFunctions.w_within_margin(0.1, 0.03)).to be_within(tolerance).of(0.9997)
    end

  end

  describe "#v_within_margin" do

    it "should return -0.194073 for (0.2, 0.3)" do
      expect(Numerics::TruncatedGaussianCorrectionFunctions.v_within_margin(0.2, 0.3)).to be_within(tolerance).of(-0.194073)
      expect(Numerics::TruncatedGaussianCorrectionFunctions.v_within_margin(0.1, 0.03)).to be_within(tolerance).of(-0.09997)
    end

  end
  
  describe "#w_exceeds_margin" do
  
    it "should return 0.657847 for (0.2, 0.3)" do
      expect(Numerics::TruncatedGaussianCorrectionFunctions.w_exceeds_margin(0.0, 0.740466)).to be_within(tolerance).of(0.76774506)
      expect(Numerics::TruncatedGaussianCorrectionFunctions.w_exceeds_margin(0.2, 0.3)).to be_within(tolerance).of(0.657847)
      expect(Numerics::TruncatedGaussianCorrectionFunctions.w_exceeds_margin(0.1, 0.03)).to be_within(tolerance).of(0.621078)
    end
  
  end
  
  describe "#v_exceeds_margin" do
  
    it "should return 0.8626174 for (0.2, 0.3)" do
      expect(Numerics::TruncatedGaussianCorrectionFunctions.v_exceeds_margin(0.0, 0.740466)).to be_within(tolerance).of(1.32145197)
      expect(Numerics::TruncatedGaussianCorrectionFunctions.v_exceeds_margin(0.2, 0.3)).to be_within(tolerance).of(0.8626174)
      expect(Numerics::TruncatedGaussianCorrectionFunctions.v_exceeds_margin(0.1, 0.03)).to be_within(tolerance).of(0.753861)
    end
  
  end

end
