module Numerics
  class TruncatedGaussianCorrectionFunctions
    class << self

      def v_exceeds_margin(team_performance_difference, draw_margin)
        denominator = GaussianDistribution.cdf(team_performance_difference - draw_margin)
        denominator < 2.222758749e-162 ?
          -team_performance_difference + draw_margin :
          GaussianDistribution.standard.at(team_performance_difference - draw_margin) / denominator
      end

      def w_exceeds_margin(team_performance_difference, draw_margin)
        denominator = GaussianDistribution.cdf(team_performance_difference - draw_margin)
        if denominator < 2.222758749e-162
          return team_performance_difference < 0.0 ? 1.0 : 0.0
        else
          v_win = v_exceeds_margin(team_performance_difference, draw_margin)
          return v_win * (v_win + team_performance_difference - draw_margin)
        end
      end

      def v_within_margin(team_performance_difference, draw_margin)
        team_performance_difference_absolute_value = team_performance_difference.abs
        denominator =
          GaussianDistribution.cdf(draw_margin - team_performance_difference_absolute_value) -
          GaussianDistribution.cdf(-draw_margin - team_performance_difference_absolute_value)
        if denominator < 2.222758749e-162
          return team_performance_difference < 0 ?
            -team_performance_difference - draw_margin :
            -team_performance_difference + draw_margin
        end
        numerator =
          GaussianDistribution.standard.at(-draw_margin - team_performance_difference_absolute_value) -
          GaussianDistribution.standard.at(draw_margin - team_performance_difference_absolute_value)
        team_performance_difference < 0 ? -numerator / denominator : numerator / denominator
      end

      def w_within_margin(team_performance_difference, draw_margin)
        team_performance_difference_absolute_value = team_performance_difference.abs
        denominator =
          GaussianDistribution.cdf(draw_margin - team_performance_difference_absolute_value) -
          GaussianDistribution.cdf(-draw_margin - team_performance_difference_absolute_value)
        return 1.0 if denominator < 2.222758749e-162
        vt = v_within_margin(team_performance_difference_absolute_value, draw_margin)
        return vt ** 2 + (
            (draw_margin - team_performance_difference_absolute_value) *
            GaussianDistribution.standard.at(draw_margin - team_performance_difference_absolute_value) -
            (-draw_margin - team_performance_difference_absolute_value) *
            GaussianDistribution.standard.at(-draw_margin - team_performance_difference_absolute_value)
          ) / denominator
      end
    end
  end
end
