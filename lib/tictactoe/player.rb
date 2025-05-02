module TicTacToe
  class Player
    attr_reader :name, :mark

    def initialize(name, mark)
      @name = name
      @mark = mark
    end

    def make_move(board)
      raise NotImplementedError, 'Must be implemented by subclass'
    end
  end
end