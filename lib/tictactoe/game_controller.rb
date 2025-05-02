# frozen_string_literal: true
module TicTacToe
  class GameController
    attr_reader :current_player, :players, :board, :state, :observers

    def initialize(player1, player2, board)
      @board = board
      @players = [player1, player2]
      @current_player = players.first
      @state = StartState.new(self)
      @observers = []
    end

    def play
      until @state.finished?
        puts "\nIt's #{@current_player.name}'s turn (#{@current_player.mark})"
        move = @current_player.make_move(@board)
        if @board.place_mark(move[:x], move[:y], current_player.mark)
          # Display the board after a successful move
          @board.display
          notify_observers
          if @board.winner?
            @state = EndState.new(self)
            # break
          elsif @board.full? # Check for a draw if no winner
            puts "The board is full. It's a draw!"
            @state = EndState.new(self)
          else
            # If the game is NOT over, switch to the other player
            switch_player
          end
        else
          puts "An invalid move was attempted."
        end
      end
      @board.display if @state.finished?
    end

    def switch_player
      @current_player = @players.find { |player| player.name != @current_player.name }
    end

    def add_observer(observer)
      @observers << observer
    end

    def notify_observers
      @observers.each { | observer| observer.update(self) }
    end
  end
end