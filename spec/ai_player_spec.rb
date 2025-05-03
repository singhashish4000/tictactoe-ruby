# spec/ai_player_spec.rb
require 'spec_helper'
require_relative '../lib/tictactoe/player'
require_relative '../lib/tictactoe/ai_player'
require_relative '../lib/tictactoe/board' # Ensure Board is required
require_relative '../lib/tictactoe/human_player' # Might need if AI interacts with Player objects directly

RSpec.describe TicTacToe::AIPlayer do
  # Using 'let' for common test objects
  let(:board) { TicTacToe::Board.new(3) }
  let(:ai_player_x) { TicTacToe::AIPlayer.new("AI X", "X", "O") } # AI plays X, opponent O
  let(:ai_player_o) { TicTacToe::AIPlayer.new("AI O", "O", "X") } # AI plays O, opponent X
  let(:human_player) { TicTacToe::HumanPlayer.new("Human", "O") } # For context if needed

  # Use 'describe' to group tests for a specific method
  describe '#make_move' do
    let(:empty_cells) { [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}] } # A sample list of empty cells

    # Stub find_empty_cells once for all tests in this describe block
    before do
      allow(ai_player_x).to receive(:find_empty_cells).and_return(empty_cells)
      allow(ai_player_o).to receive(:find_empty_cells).and_return(empty_cells)
      # We also need to allow the board's size to be accessed, as it's used by choose_strategic_or_random_move
      allow(board).to receive(:size).and_return(3)
    end

    it 'returns a winning move if one is available (AI plays X)' do
      winning_move = {x: 0, y: 2}

      # Stub find_strategic_move to return the winning move for AI's mark ('X')
      allow(ai_player_x).to receive(:find_strategic_move).with(board, empty_cells, 'X').and_return(winning_move)
      # Stub find_strategic_move to return nil for the opponent's mark ('O') - ensures win is prioritized over block
      allow(ai_player_x).to receive(:find_strategic_move).with(board, empty_cells, 'O').and_return(nil)
      # Stub the strategic/random method as it should not be reached if a win is found
      allow(ai_player_x).to receive(:choose_strategic_or_random_move).and_return(nil)

      move = ai_player_x.make_move(board)
      expect(move).to eq(winning_move)
    end

    it 'returns a blocking move if no winning move is available but a blocking move is (AI plays O)' do
      blocking_move = {x: 0, y: 2}

      # Stub find_strategic_move to return nil for AI's winning moves ('O')
      allow(ai_player_o).to receive(:find_strategic_move).with(board, empty_cells, 'O').and_return(nil)
      # Stub find_strategic_move to return a blocking move for the opponent's mark ('X')
      allow(ai_player_o).to receive(:find_strategic_move).with(board, empty_cells, 'X').and_return(blocking_move)
      # Stub the strategic/random method as it should not be reached
      allow(ai_player_o).to receive(:choose_strategic_or_random_move).and_return(nil)

      move = ai_player_o.make_move(board)
      expect(move).to eq(blocking_move)
    end

    it 'returns a strategic/random move if no win or block is available' do
      strategic_move = {x: 1, y: 1} # Example strategic move (center)

      # Stub find_strategic_move to return nil for both AI's mark and opponent's mark
      allow(ai_player_x).to receive(:find_strategic_move).with(board, empty_cells, 'X').and_return(nil)
      allow(ai_player_x).to receive(:find_strategic_move).with(board, empty_cells, 'O').and_return(nil)
      # Stub choose_strategic_or_random_move to return a specific strategic move
      allow(ai_player_x).to receive(:choose_strategic_or_random_move).with(empty_cells, board.size).and_return(strategic_move)

      move = ai_player_x.make_move(board)
      expect(move).to eq(strategic_move)
    end

    # You could add more tests here to cover different scenarios or
    # edge cases like an empty empty_cells array (though the code checks for that).
  end

  # Use 'describe' with '#method_name' for instance methods
  describe '#find_empty_cells' do
    it 'returns a list of all empty cells as hashes' do
      empty_cells = ai_player_x.send(:find_empty_cells, board) # Test private method using send
      expect(empty_cells.size).to eq(9) # 3x3 board starts with 9 empty cells
      empty_cells.each do |cell|
        expect(cell).to be_an(Hash)
        expect(cell).to include(:x, :y)
      end
    end

    it 'does not include taken cells in the list' do
      board.place_mark(0, 0, 'X')
      board.place_mark(1, 1, 'O')
      empty_cells = ai_player_x.send(:find_empty_cells, board)

      expect(empty_cells.size).to eq(7)
      expect(empty_cells).not_to include({x: 0, y: 0})
      expect(empty_cells).not_to include({x: 1, y: 1})
    end
  end

  describe '#find_strategic_move' do
    context 'when a winning move is available for the checking mark' do
      it 'returns the coordinates of the winning move' do
        # Setup board so AI (X) can win horizontally at (0, 2)
        board.place_mark(0, 0, 'X')
        board.place_mark(0, 1, 'X')
        empty_cells = ai_player_x.send(:find_empty_cells, board)

        # Check for winning move for 'X' (AI's mark)
        winning_move = ai_player_x.send(:find_strategic_move, board, empty_cells, 'X')
        expect(winning_move).to eq({x: 0, y: 2})
      end

      it 'returns the coordinates of the winning move for a diagonal win' do
        # Setup board so AI (O) can win diagonally at (0, 0)
        board.place_mark(1, 1, 'O')
        board.place_mark(2, 2, 'O')
        empty_cells = ai_player_o.send(:find_empty_cells, board)

        # Check for winning move for 'O' (AI's mark)
        winning_move = ai_player_o.send(:find_strategic_move, board, empty_cells, 'O')
        expect(winning_move).to eq({x: 0, y: 0})
      end
    end

    context 'when no winning move is available for the checking mark' do
      it 'returns nil' do
        # Board state with no immediate win for X or O
        board.place_mark(0, 0, 'X')
        board.place_mark(0, 1, 'O')
        empty_cells = ai_player_x.send(:find_empty_cells, board)

        expect(ai_player_x.send(:find_strategic_move, board, empty_cells, 'X')).to be_nil
        expect(ai_player_x.send(:find_strategic_move, board, empty_cells, 'O')).to be_nil
      end
    end
  end

  describe '#choose_strategic_or_random_move' do
    it 'prioritizes the center square when available' do
      empty_cells = ai_player_x.send(:find_empty_cells, board) # All cells are empty
      strategic_move = ai_player_x.send(:choose_strategic_or_random_move, empty_cells, 3)
      expect(strategic_move).to eq({x: 1, y: 1}) # Center for 3x3
    end

    it 'prioritizes a corner square if the center is taken' do
      board.place_mark(1, 1, 'O') # Center is taken
      empty_cells = ai_player_x.send(:find_empty_cells, board)
      strategic_move = ai_player_x.send(:choose_strategic_or_random_move, empty_cells, 3)

      corners = [{x: 0, y: 0}, {x: 0, y: 2}, {x: 2, y: 0}, {x: 2, y: 2}]
      expect(corners).to include(strategic_move) # Should be one of the corners
    end

    it 'falls back to a random empty cell if no strategic spots are available' do
      # Fill center and all corners
      board.place_mark(1, 1, 'O')
      board.place_mark(0, 0, 'X') ; board.place_mark(0, 2, 'X')
      board.place_mark(2, 0, 'O') ; board.place_mark(2, 2, 'O')
      empty_cells = ai_player_x.send(:find_empty_cells, board) # Remaining cells are edges

      strategic_move = ai_player_x.send(:choose_strategic_or_random_move, empty_cells, 3)
      expect(empty_cells).to include(strategic_move) # Should be one of the remaining empty cells
      expect(strategic_move).not_to eq({x: 1, y: 1}) # Should not be center
      expect([{x: 0, y: 0}, {x: 0, y: 2}, {x: 2, y: 0}, {x: 2, y: 2}]).not_to include(strategic_move) # Should not be a corner
    end
  end

  it 'returns a valid empty cell' do
    move = ai_player_x.make_move(board)
    expect(board.valid_move?(move[:x], move[:y])).to be(true)
  end
end