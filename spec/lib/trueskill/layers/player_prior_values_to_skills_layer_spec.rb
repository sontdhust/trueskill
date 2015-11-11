require File.expand_path('spec/spec_helper.rb')

describe Trueskill::Layers::PlayerPriorValuesToSkillsLayer do

  before :each do
    @teams = create_teams
    @results = {@team1 => 1, @team2 => 2, @team3 => 3}
    @graph = Trueskill::TrueskillFactorGraph.new(@results)
    @layer = Trueskill::Layers::PlayerPriorValuesToSkillsLayer.new(@graph, @teams)
  end

  describe "#build" do

    it "should add 4 local_factors" do
      expect {
        @layer.build_layer
      }.to change(@layer.local_factors, :size).by(4)
    end

    it "should add 3 output_variables_groups variables" do
      expect {
        @layer.build_layer
      }.to change(@layer.output_variables_groups, :size).by(3)
    end

  end

  describe "#prior_schedule" do

    before :each do
      @layer.build_layer
    end

    it "should return a sequence-schedule" do
      expect(@layer.create_prior_schedule).to be_kind_of(FactorGraphs::ScheduleSequence)
    end

  end
end
