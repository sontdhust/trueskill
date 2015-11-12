module Trueskill
  module Layers
    class PlayerPriorValuesToSkillsLayer < TrueskillLayerBase

      def initialize(parent_factor_graph, teams)
        super(parent_factor_graph)
        @teams = teams
      end

      def build_layer
        @teams.each do |current_team|
          current_team_skills = []
          current_team.each do |current_player, current_rating|
            player_skill = @parent_factor_graph.variable_factory.create_keyed_variable(current_player)
            @local_factors << Trueskill::Factors::GaussianPriorFactor.new(
              current_rating.mean,
              current_rating.standard_deviation ** 2 + @parent_factor_graph.game_info[:dynamics_factor] ** 2,
              player_skill
            )
            current_team_skills << player_skill
          end
          @output_variables_groups << current_team_skills
        end
      end

      def create_prior_schedule
        FactorGraphs::ScheduleSequence.new(@local_factors.map { |prior| FactorGraphs::ScheduleStep.new(prior, 0) })
      end
    end
  end
end
