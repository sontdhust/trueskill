module Trueskill
  class Player
    attr_reader :name, :partial_play_percentage

    def initialize(name = '', partial_play_percentage = 1.0)
      @name = name
      @partial_play_percentage = partial_play_percentage
    end

    def ==(other)
      @name == name
    end

    alias eql? ==

    def hash
      @name.hash
    end
  end
end
