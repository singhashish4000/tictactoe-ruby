# spec/command_manager_and_command_spec.rb
require 'spec_helper'
require_relative '../lib/tictactoe/command_manager'
require_relative '../lib/tictactoe/place_mark_command'
require_relative '../lib/tictactoe/board'

# Group tests for CommandManager and PlaceMarkCommand together as they are tightly coupled
RSpec.describe "Command Pattern" do
  let(:board) { TicTacToe::Board.new(3) }
  let(:command_manager) { TicTacToe::CommandManager.new }
  let(:move_command_x) { TicTacToe::PlaceMarkCommand.new(board, 0, 0, 'X') }
  let(:move_command_o) { TicTacToe::PlaceMarkCommand.new(board, 0, 1, 'O') }


  describe TicTacToe::PlaceMarkCommand do
    describe '#execute' do
      it 'places the mark on the board for a valid move and returns true' do
        expect(move_command_x.execute).to be(true)
        expect(board.grid[0][0]).to eq('X')
        expect(move_command_x).to be_executed # Use predicate matcher
      end

      it 'returns false and does not place mark if the move is invalid' do
        board.place_mark(0, 0, 'X') # Pre-occupy the cell
        invalid_command = TicTacToe::PlaceMarkCommand.new(board, 0, 0, 'O') # Command for the taken cell

        expect(invalid_command.execute).to be(false)
        expect(board.grid[0][0]).to eq('X') # Board should not change
        expect(invalid_command).not_to be_executed # Should not be marked as executed
      end
    end

    describe '#undo' do
      it 'clears the mark from the board if the command was executed' do
        move_command_x.execute # Execute first
        expect(board.grid[0][0]).to eq('X')

        expect(move_command_x.undo).to be(true)
        expect(board.grid[0][0]).to be_nil
        expect(move_command_x).not_to be_executed # Should not be marked as executed after undo
      end

      it 'returns false and does nothing if the command was not executed' do
        # Do NOT call execute
        expect(board.grid[0][0]).to be_nil # Ensure it's empty initially

        expect(move_command_x.undo).to be(false)
        expect(board.grid[0][0]).to be_nil # Board should remain unchanged
      end
    end
  end

  describe TicTacToe::CommandManager do
    describe '#execute' do
      it 'executes the command and adds it to the history' do
        expect(command_manager.history).to be_empty

        expect(command_manager.execute(move_command_x)).to be(true) # Execute first command
        expect(command_manager.history.size).to eq(1)
        expect(command_manager.history).to include(move_command_x)
        expect(board.grid[0][0]).to eq('X') # Command should have been executed

        expect(command_manager.execute(move_command_o)).to be(true) # Execute second command
        expect(command_manager.history.size).to eq(2)
        expect(command_manager.history).to include(move_command_o)
        expect(board.grid[0][1]).to eq('O') # Second command should have been executed

        expect(command_manager.history.last).to be(move_command_o) # Check the order
      end

      it 'does not add the command to history if execution fails' do
        board.place_mark(0, 0, 'X') # Pre-occupy cell
        invalid_command = TicTacToe::PlaceMarkCommand.new(board, 0, 0, 'O') # Command for taken cell

        expect(command_manager.history).to be_empty
        expect(command_manager.execute(invalid_command)).to be(false) # Execution fails

        expect(command_manager.history).to be_empty # History should remain empty
      end
    end

    describe '#undo' do
      it 'removes the last command from history and calls its undo method' do
        command_manager.execute(move_command_x)
        command_manager.execute(move_command_o) # History: [cmd_x, cmd_o]

        expect(command_manager.history.size).to eq(2)
        expect(board.grid[0][1]).to eq('O') # Board state before undo

        expect(command_manager.undo).to be(true) # Undo the last command (cmd_o)
        expect(command_manager.history.size).to eq(1)
        expect(board.grid[0][1]).to be_nil # Mark from cmd_o should be removed
        expect(command_manager.history.last).to be(move_command_x) # cmd_x should be the last

        expect(command_manager.undo).to be(true) # Undo the next command (cmd_x)
        expect(command_manager.history.size).to eq(0)
        expect(board.grid[0][0]).to be_nil # Mark from cmd_x should be removed
        expect(command_manager.history).to be_empty # History should be empty
      end

      it 'returns false and does nothing if the history is empty' do
        expect(command_manager.history).to be_empty

        expect(command_manager.undo).to be(false)
        expect(command_manager.history).to be_empty # History remains empty

        # Board should remain unchanged (assuming it was initially empty or already verified)
      end
    end

    # Note: Testing the specific `undo_last_two_moves` logic would go in the GameController spec,
    # as that's where that specific sequence of command_manager.undo calls is implemented.
  end
end