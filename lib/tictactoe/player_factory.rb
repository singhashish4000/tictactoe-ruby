# player_factory.rb
# require_relative 'player'
# require_relative 'human_player'
# require_relative 'ai_player'

module TicTacToe
  class PlayerFactory
    def self.create(definition, all_definitions)
      case definition[:type]
      when :human
        HumanPlayer.new(definition[:name], definition[:mark])
      when :ai
        opponent_definition = all_definitions.find { |d| d[:mark] != definition[:mark] }
        opponent_mark = opponent_definition ? opponent_definition[:mark] : nil # Get opponent's mark
        AIPlayer.new(definition[:name], definition[:mark], opponent_mark)
      else
        raise ArgumentError, "Unknown player type: #{definition[:type]}"
      end
    end
  end
end