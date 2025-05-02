# player_factory.rb
# require_relative 'player'
# require_relative 'human_player'
# require_relative 'ai_player'

module TicTacToe
  class PlayerFactory
    def self.create(name, mark, type)
      case type
      when :human
        HumanPlayer.new(name, mark)
      when :ai
        AIPlayer.new(name, mark)
      else
        raise ArgumentError, "Unknown player type: #{type}"
      end
    end
  end
end