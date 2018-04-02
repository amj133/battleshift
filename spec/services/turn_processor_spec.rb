require 'rails_helper'

describe TurnProcessor do
    let(:board) { double('board') }
    let(:player) { Player.new(board, '12345') }
    let(:player_2) { Player.new(board, '23456') }

    let(:game) { Game.new(player_1: player, player_2: player_2) }

    subject { TurnProcessor.new(game, 'A1', board, player) }

  context 'attributes' do
    it 'has a status' do
      expect(subject.status).to eq(200)
    end
  end

  context 'instance methods' do
    describe '#run!' do
      it 'attacks the opponent and returns the current status of the game' do
        allow_any_instance_of(Shooter).to receive(:fire!).and_return('Miss')
        allow_any_instance_of(Shooter).to receive(:message).and_return(nil)
        allow(board).to receive(:conquered?).and_return(false)

        expect(game.current_turn).to eq('player_1')

        subject.run!

        expect(game.current_turn).to eq('player_2')
        expect(subject.message).to eq('Your shot resulted in a Miss.')
      end

      it 'raises an error when a player performs an invalid move' do
        game.winner = ('jane@gmail.com')

        subject.run!

        expect(subject.message).to eq('Invalid move. Game over.')
        expect(subject.status).to eq(400)
      end
    end

    describe '#message' do
      it 'returns the result of the hit and if the battleship is sunk or the game is over' do
        allow_any_instance_of(Shooter).to receive(:fire!).and_return('Hit')
        allow_any_instance_of(Shooter).to receive(:message).and_return('Battleship sunk.')
        allow(board).to receive(:conquered?).and_return(false)

        subject.run!

        expect(subject.message).to eq('Your shot resulted in a Hit. Battleship sunk.')
      end
    end
  end
end
