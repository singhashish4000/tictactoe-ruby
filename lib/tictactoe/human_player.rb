# human_player.rb
# require_relative 'player'

module TicTacToe
  class HumanPlayer < Player
    def make_move(board)
      puts "#{name} (#{mark}), enter your move (row col):"
      loop do
        input = gets.chomp.split.map(&:to_i)
        if input.length == 2
          x, y = input
          if board.valid_move?(x, y)
            return {x: x, y: y}
          else
            puts "Invalid move. The cell is already taken or out of bounds."
          end
        else
          puts "Invalid input format. Please enter row and column like '0 0'."
        end
      end
    end
  end
end