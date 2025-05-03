# spec/player_factory_spec.rb
require 'spec_helper'
require_relative '../lib/tictactoe/player'
require_relative '../lib/tictactoe/player_factory'
require_relative '../lib/tictactoe/human_player'
require_relative '../lib/tictactoe/ai_player'

RSpec.describe TicTacToe::PlayerFactory do
  let(:all_definitions) do
    [
      { name: "Human Player", mark: "X", type: :human },
      { name: "AI Player", mark: "O", type: :ai }
    ]
  end

  describe '.create' do
    it 'creates a HumanPlayer when type is :human' do
      definition = all_definitions.first
      player = TicTacToe::PlayerFactory.create(definition, all_definitions)

      expect(player).to be_an(TicTacToe::HumanPlayer)
      expect(player.name).to eq("Human Player")
      expect(player.mark).to eq("X")
    end

    it 'creates an AIPlayer when type is :ai and assigns opponent mark' do
      definition = all_definitions.last
      player = TicTacToe::PlayerFactory.create(definition, all_definitions)

      expect(player).to be_an(TicTacToe::AIPlayer)
      expect(player.name).to eq("AI Player")
      expect(player.mark).to eq("O")
      expect(player.opponent_mark).to eq("X") # AI O's opponent is X
    end

    it 'raises an ArgumentError for an unknown player type' do
      unknown_definition = { name: "Unknown", mark: "?", type: :unknown }
      expect { TicTacToe::PlayerFactory.create(unknown_definition, all_definitions) }.to raise_error(ArgumentError, "Unknown player type: unknown")
    end
  end
end