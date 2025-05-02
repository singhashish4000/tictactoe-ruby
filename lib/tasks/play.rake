# Rakefile
# lib/tictactoe/tictactoe.rb
require_relative '../tictactoe/player'
require_relative '../tictactoe/ai_player'
require_relative '../tictactoe/human_player'
require_relative '../tictactoe/board'
require_relative '../tictactoe/command_manager'
require_relative '../tictactoe/game_builder'
require_relative '../tictactoe/game_controller'
require_relative '../tictactoe/game_logger'
require_relative '../tictactoe/game_state'
require_relative '../tictactoe/logging_player'
require_relative '../tictactoe/player_factory'

# This file acts as a central point to require all game components.
# The module TicTacToe is defined within the individual files.

task :default => :play

task :play do
  # binding.pry
  game = TicTacToe::GameBuilder.new
                               .with_player("Player 1", "X", type: :human)
                               .with_player("Player 2", "O", type: :ai)
                               .with_board(3)
                               .build

  logger = TicTacToe::GameLogger.new
  logging_player1 = TicTacToe::LoggingPlayer.new(game.players[0], logger)
  logging_player2 = TicTacToe::LoggingPlayer.new(game.players[1], logger)

  game.players[0] = logging_player1
  game.players[1] = logging_player2

  # game.add_observer(logger)

  game.play

  if game.board.winner?
    puts "#{game.board.winner?} wins!"
  elsif game.board.full?
    puts "It's a draw!"
  end
end