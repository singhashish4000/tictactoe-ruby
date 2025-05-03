# spec/board_spec.rb
require 'spec_helper' # Include the RSpec helper
require_relative '../lib/tictactoe/board' # Require the class being tested

RSpec.describe TicTacToe::Board do
  # Use 'let' for subject under test or common objects, run before each example
  let(:board) { TicTacToe::Board.new(3) }

  # Use 'describe' to group tests for a specific method or feature
  describe '#initialize' do
    it 'creates a board with the specified size' do
      expect(board.size).to eq(3)
    end

    it 'creates a grid as a 2D array of nils' do
      expect(board.grid).to be_an(Array) # Check if it's an Array
      expect(board.grid.size).to eq(3)    # Check number of rows

      board.grid.each do |row|
        expect(row).to be_an(Array)      # Check if each row is an Array
        expect(row.size).to eq(3)        # Check number of columns in each row
        expect(row).to all(be_nil)       # Check if all cells in the row are nil
      end
    end
  end

  describe '#place_mark' do
    it 'places a mark on a valid empty cell and returns true' do
      expect(board.place_mark(0, 0, 'X')).to be(true) # Use be(true) for boolean true
      expect(board.grid[0][0]).to eq('X')
    end

    it 'returns false and does not place mark if cell is taken' do
      board.place_mark(0, 0, 'X')
      expect(board.place_mark(0, 0, 'O')).to be(false) # Use be(false) for boolean false
      expect(board.grid[0][0]).to eq('X') # Ensure it didn't change
    end

    it 'returns false and does not place mark for out of bounds coordinates' do
      expect(board.place_mark(3, 3, 'X')).to be(false)
      expect(board.place_mark(0, 3, 'X')).to be(false)
      expect(board.place_mark(-1, 0, 'X')).to be(false)
    end
  end

  describe '#valid_move?' do
    it 'returns true for an empty cell within bounds' do
      expect(board.valid_move?(1, 1)).to be(true)
    end

    it 'returns false for a cell that is already taken' do
      board.place_mark(1, 1, 'X')
      expect(board.valid_move?(1, 1)).to be(false)
    end

    it 'returns false for coordinates that are out of bounds' do
      expect(board.valid_move?(3, 0)).to be(false)
      expect(board.valid_move?(-1, 0)).to be(false)
    end
  end

  describe '#full?' do
    it 'returns false on a new, empty board' do
      expect(board).not_to be_full # Using RSpec's predicate matcher
    end

    it 'returns true when all cells are filled' do
      (0...3).each do |i|
        (0...3).each do |j|
          board.place_mark(i, j, 'X')
        end
      end
      expect(board).to be_full # Using RSpec's predicate matcher
    end
  end

  describe '#winner?' do
    it 'returns the winning mark for a horizontal win' do
      board.place_mark(0, 0, 'X')
      board.place_mark(0, 1, 'X')
      board.place_mark(0, 2, 'X')
      expect(board.winner?).to eq('X')
    end

    it 'returns the winning mark for a vertical win' do
      board.place_mark(0, 0, 'O')
      board.place_mark(1, 0, 'O')
      board.place_mark(2, 0, 'O')
      expect(board.winner?).to eq('O')
    end

    it 'returns the winning mark for a diagonal win (TL-BR)' do
      board.place_mark(0, 0, 'X')
      board.place_mark(1, 1, 'X')
      board.place_mark(2, 2, 'X')
      expect(board.winner?).to eq('X')
    end

    it 'returns the winning mark for a diagonal win (TR-BL)' do
      board.place_mark(0, 2, 'O')
      board.place_mark(1, 1, 'O')
      board.place_mark(2, 0, 'O')
      expect(board.winner?).to eq('O')
    end

    it 'returns nil when there is no winner' do
      board.place_mark(0, 0, 'X')
      board.place_mark(0, 1, 'O')
      board.place_mark(0, 2, 'X')
      board.place_mark(1, 0, 'O')
      expect(board.winner?).to be_nil
    end

    it 'returns nil in a full board draw game' do
      # Simulate a draw game
      board.place_mark(0, 0, 'X') ; board.place_mark(0, 1, 'O') ; board.place_mark(0, 2, 'X')
      board.place_mark(1, 0, 'O') ; board.place_mark(1, 1, 'O') ; board.place_mark(1, 2, 'X')
      board.place_mark(2, 0, 'X') ; board.place_mark(2, 1, 'X') ; board.place_mark(2, 2, 'O')
      expect(board.winner?).to be_nil
      expect(board).to be_full
    end
  end

  describe '#clear_cell' do
    it 'sets a cell to nil and returns true if coordinates are valid' do
      board.place_mark(1, 1, 'X')
      expect(board.grid[1][1]).to eq('X')
      expect(board.clear_cell(1, 1)).to be(true)
      expect(board.grid[1][1]).to be_nil
      expect(board.valid_move?(1, 1)).to be(true) # Should now be a valid move again
    end

    it 'returns false for out of bounds coordinates' do
      expect(board.clear_cell(3, 3)).to be(false)
      expect(board.clear_cell(-1, 0)).to be(false)
    end
  end

  describe '#dup' do
    it 'creates a new Board object' do
      copied_board = board.deep_dup
      expect(copied_board).not_to be(board) # Ensure it's a different object
      expect(copied_board).to be_an(TicTacToe::Board)
    end

    it 'creates a deep copy of the grid' do
      board.place_mark(0, 0, 'X')
      copied_board = board.deep_dup

      expect(copied_board.grid).not_to be(board.grid) # Ensure the grid array itself is different
      expect(copied_board.grid).to eq(board.grid)    # Ensure the content is the same initially

      # Modify the copy
      copied_board.place_mark(1, 1, 'O')

      # Ensure changes to copy do not affect the original
      expect(copied_board.grid[1][1]).to eq('O')
      expect(board.grid[1][1]).to be_nil
    end
  end
end