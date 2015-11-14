module Trueskill
  module Layers
    class TeamDifferencesComparisonLayer < TrueskillLayerBase

      def initialize(parent_factor_graph, team_ranks)
        super(parent_factor_graph)
        @team_ranks = team_ranks
        game_info = @parent_factor_graph.game_info
        @epsilon = Numerics::GaussianDistribution.inv_cdf(
          0.5 * (game_info[:draw_probability] + 1)) * Math.sqrt(1 + 1) * game_info[:beta]
      end

      def build_layer
        (0..(@input_variables_groups.size - 1)).each do |i|
          if @team_ranks[i] == @team_ranks[i + 1]
            @local_factors << Trueskill::Factors::GaussianWithinFactor.new(@epsilon, @input_variables_groups[i][0])
          else
            @local_factors << Trueskill::Factors::GaussianGreaterThanFactor.new(@epsilon, @input_variables_groups[i][0])
          end
        end
      end
    end
  end
end
