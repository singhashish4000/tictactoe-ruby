module TicTacToe
  class PlaceMarkCommand
    attr_reader :x, :y, :mark

    def initialize(board, x, y, mark)
      @board = board
      @x = x
      @y = y
      @mark = mark
      # Flag to track if command was successfully executed
      @executed = false
    end

    def execute
      success = @board.place_mark(@x, @y, @mark)
      @executed = success
      success
    end

    def undo
      # Only undo if command was previously executed
      if @executed
        success = @board.clear_cell(@x, @y)
        # If clearing is success, mark it as not executed as nothing to undo then
        @executed = !success
        success
      else
        false
      end
    end
  end
end