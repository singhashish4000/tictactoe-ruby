module TicTacToe
  class AIPlayer < Player
    attr_reader :opponent_mark

    def initialize(name, mark, opponent_mark)
      super(name, mark)
      @opponent_mark = opponent_mark
    end
    def make_non_smart_move(board)
      empty_cells = []
      (0..board.size - 1).each do |x|
        (0..board.size - 1).each do |y|
          empty_cells << {x: x, y: y}  if board.valid_move?(x, y)
        end
      end
      empty_cells.sample
    end

    def make_move(board)
      empty_cells = find_empty_cells(board)
      return nil if empty_cells.nil?

      winning_move = find_strategic_move(board, empty_cells, @mark)
      return winning_move if winning_move

      blocking_move = find_strategic_move(board, empty_cells, @opponent_mark)
      return blocking_move if blocking_move

      choose_strategic_or_random_move(empty_cells, board.size)
    end

    private

    def find_empty_cells(board)
      empty_cells = []
      (0...board.size).each do |x|
        (0...board.size).each do |y|
          empty_cells << {x: x, y: y}  if board.valid_move?(x, y)
        end
      end
      empty_cells
    end

    def find_strategic_move(board, empty_cells, mark_to_check)
      empty_cells.each do |cell|
        copied_board = board.deep_dup
        copied_board.place_mark(cell[:x], cell[:y], mark_to_check)

        return cell if copied_board.winner? == mark_to_check
      end
      nil # No strategic move found for the given mark
    end

    def choose_strategic_or_random_move(empty_cells, board_size)
      # Prioritize the center square if available
      center = {x: board_size / 2, y: board_size / 2}
      return center if empty_cells.include?(center)

      # Prioritize corner squares if available
      corners = [
        {x: 0, y: 0},
        {x: 0, y: board_size - 1},
        {x: board_size - 1, y: 0},
        {x: board_size - 1, y: board_size - 1}
      ]
      available_corners = empty_cells.select { |cell| corners.include?(cell) }
      return available_corners.sample unless available_corners.empty?

      # Prioritize edge squares (non-corner) if available (optional but makes AI better)
      # For a 3x3 board, this would be (0,1), (1,0), (1,2), (2,1)
      # This requires more complex logic to find edges for variable size boards.
      # For simplicity, let's stick to center/corners for now, or just random.

      # Fallback to picking any random empty cell if no strategic moves available
      empty_cells.sample
    end
  end
end