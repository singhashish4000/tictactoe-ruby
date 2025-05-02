module TicTacToe
  class LoggingPlayer < Player
    def initialize(player, logger)
      @player = player
      @logger = logger
      super(player.name, player.mark)  # sets up @name and @mark in the Player superclass
    end

    def make_move(board)
      move = @player.make_move(board)
      @logger.log_move(@player, move)
      move
    end
  end
end
