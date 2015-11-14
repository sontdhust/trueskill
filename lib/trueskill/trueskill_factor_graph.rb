module Trueskill
  class TrueskillFactorGraph < FactorGraphs::FactorGraph

    attr_reader :game_info

    def initialize(teams_ranks_hash, game_info = {})
      # Sort team ranks by ascending order
      sorted_teams_ranks_hash = Hash[teams_ranks_hash.sort_by(&:last)]
      @teams = sorted_teams_ranks_hash.keys
      @ranks = sorted_teams_ranks_hash.values

      @game_info = {
        :initial_mean => 25.0,                        # μ
        :initial_standard_deviation => 25.0 / 3.0,    # σ
        :beta => 25.0 / 6.0,                          # β
        :dynamics_factor => 25.0 / 300.0,             # τ
        :draw_probability => 0.1
      }.merge(game_info)
      @variable_factory = FactorGraphs::VariableFactory.new(-> { Numerics::GaussianDistribution.from_precision_mean(0.0, 0.0) })

      @prior_layer = Trueskill::Layers::PlayerPriorValuesToSkillsLayer.new(self, @teams)
      @layers = [
        @prior_layer,
        Trueskill::Layers::PlayerSkillsToPerformancesLayer.new(self),
        Trueskill::Layers::PlayerPerformancesToTeamPerformancesLayer.new(self),
        Trueskill::Layers::IteratedTeamDifferencesInnerLayer.new(
          self,
          Trueskill::Layers::TeamPerformancesToTeamPerformanceDifferencesLayer.new(self),
          Trueskill::Layers::TeamDifferencesComparisonLayer.new(self, @ranks)
        )
      ]
    end

    def update!
      build_graph
      run_schedule
      get_updated_ratings(true)
      # get_probability_of_ranking
    end

    def update
      build_graph
      run_schedule
      get_updated_ratings
      # get_probability_of_ranking
    end

    private

    def build_graph
      last_output = nil
      @layers.each do |current_layer|
        current_layer.input_variables_groups = last_output if last_output != nil
        current_layer.build_layer
        last_output = current_layer.output_variables_groups
      end
    end

    def run_schedule
      schedules = @layers.map(&:create_prior_schedule) + @layers.reverse.map(&:create_posterior_schedule)
      FactorGraphs::ScheduleSequence.new(schedules.compact).visit
    end

    def get_updated_ratings(forced_update = false)
      new_ratings = {}
      @prior_layer.output_variables_groups.each do |current_team|
        current_team.each do |current_player|
          new_rating = Rating.new(current_player.value.mean, current_player.value.standard_deviation)
          new_ratings[current_player.key] = new_rating
          if forced_update
            @teams.each do |team|
              team[current_player.key] = new_rating if team.key? current_player.key
            end
          end
        end
      end
      new_ratings
    end

    def get_probability_of_ranking
      factor_list = []
      @layers.each do |current_layer|
        current_layer.local_factors.each do |current_factor|
          factor_list << current_factor
        end
      end
      sum_log_z, sum_log_s = 0.0, 0.0
      factor_list.each do |f|
        f.reset_marginals
      end
      (0..(factor_list.size - 1)).each do |i|
        f = factor_list[i]
        (0..(f.number_of_messages - 1)).each do |j|
          sum_log_z += f.send_message_at(j)
        end
      end
      factor_list.each do |f|
        sum_log_s += f.log_normalization
      end
      log_z = sum_log_z + sum_log_s
      Math.exp(log_z)
    end
  end
end
