module TicTacToe
  class GameLogger
    def log_move(player, move)
      puts "#{player.name} (#{player.mark}) made a move at (#{move[:x]}, #{move[:y]})"
    end
  end
end