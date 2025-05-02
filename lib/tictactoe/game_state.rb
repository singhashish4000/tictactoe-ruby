module TicTacToe
  class GameState
    def finished?
      raise NotImplementedError, 'Must be implemented by a subclass'
    end
  end

  class StartState < GameState
    def initialize(game)
      @game = game
    end

    def finished?
      false
    end
  end

  class EndState < GameState
    def initialize(game)
      @game = game
    end

    def finished?
      true
    end
  end
end