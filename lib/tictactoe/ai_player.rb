module TicTacToe
  class AIPlayer < Player
    def make_move(board)
      empty_cells = []
      (0..board.size - 1).each do |x|
        (0..board.size - 1).each do |y|
          empty_cells << {x: x, y: y}  if board.valid_move?(x, y)
        end
      end
      empty_cells.sample
    end
  end
end