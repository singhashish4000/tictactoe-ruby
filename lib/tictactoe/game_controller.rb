require_relative 'place_mark_command'
module TicTacToe
  class GameController
    attr_reader :current_player, :players, :board, :state, :observers
    attr_reader :command_manager

    def initialize(player1, player2, board)
      @board = board
      @players = [player1, player2]
      @current_player = @players.first
      @state = StartState.new(self)
      @observers = []
      @command_manager = CommandManager.new # Instantiate CommandManager
    end

    def play
      puts "Game started."
      @board.display

      until @state.finished?
        puts "\nIt's #{@current_player.name}'s turn (#{@current_player.mark})"

        # Get the move or command from the current player's input
        move_or_command = get_player_input

        # Process the input: could be an undo request or a regular move
        process_player_input(move_or_command)

        # The loop continues, checking the game state after each processed input
      end

      puts "Game finished."
      @board.display if @state.finished? && !@board.winner? # Display final board state if it was a draw
    end

    private

    def get_player_input
      @current_player.make_move(@board)
    end

    def process_player_input(move_or_command)
      case move_or_command
      when :undo
        handle_undo_request
      when Hash
        handle_player_move(move_or_command) # Handle a regular move
      else
        handle_unexpected_input
      end
    end


    def handle_undo_request
      is_human = @current_player.is_a?(HumanPlayer) || (@current_player.is_a?(LoggingPlayer) && @current_player.instance_variable_get(:@player).is_a?(HumanPlayer))

      if is_human
        # Attempt to undo the last two moves (Human's last turn + AI's response)
        undo_last_two_moves
      else
        puts "Undo command is only available for Human players."
      end
    end

    def undo_last_two_moves
      if @command_manager.undo && @command_manager.undo
        puts "Both moves undone. Your turn again."
        @board.display
      else
        puts "Could not undo the second to last move. Only one move was undone."
      end
    end

    # Handles a regular player move (creating and executing the command)
    def handle_player_move(move)
      command = PlaceMarkCommand.new(@board, move[:x], move[:y], @current_player.mark)

      if @command_manager.execute(command)
        @board.display
        notify_observers
        check_and_handle_game_end
      else
        handle_invalid_move
      end
    end

    def check_and_handle_game_end
      if @board.winner?
        puts "#{@current_player.name} (#{@current_player.mark}) wins!"
        @state = EndState.new(self)
      elsif @board.full?
        puts "The board is full. It's a draw!"
        @state = EndState.new(self)
      else
        switch_player # Switch player after a valid, non-ending move
      end
    end

    def handle_invalid_move
      puts "Invalid move attempted. Please enter valid coordinates."
    end

    def handle_unexpected_input
      puts "Received unexpected input format from player. Please try again."
    end

    def switch_player
      @current_player = @players.find { |p| p.name != @current_player.name }
    end

    def add_observer(observer)
      @observers << observer
    end

    def notify_observers
      # If observers needed to react to game state changes (not just moves),
      # their update method would be called here.
      # Example: @observers.each { |observer| observer.update(self, :board_changed) }
    end
  end
end