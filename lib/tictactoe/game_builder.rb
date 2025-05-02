module TicTacToe
  class GameBuilder
    def initialize
      @players = []
      @board = Board.new
    end

    def with_player(name, mark, type: :human)
      player = PlayerFactory.create(name, mark, type)
      @players << player
      self
    end

    def with_board(size = 3)
      @board = Board.new(size)
      self
    end

    def build
      GameController.new(@players[0], @players[1], @board)
    end
  end
end