module TicTacToe
  class GameBuilder
    def initialize
      # @players = []
      @player_definitions = []
      @board = Board.new
    end

    def with_player(name, mark, type: :human)
      # player = PlayerFactory.create(name, mark, type)
      # @players << player
      @player_definitions << { name: name, mark: mark, type: type }
      self
    end

    def with_board(size = 3)
      @board = Board.new(size)
      self
    end

    def build
      # create players
      @players = @player_definitions.map do |player_definition|
        PlayerFactory.create(player_definition, @player_definitions)
      end
      unless @players.length == 2
        raise ArgumentError, "Game requires exactly two players."
      end
      GameController.new(@players[0], @players[1], @board)
    end
  end
end