require 'rails_helper'

describe Shooter do
  context 'instance methods' do
    describe '#fire!' do
      it 'attacks the space a user targets' do
        space = spy('space')
        target = 'A1'

        allow_any_instance_of(Board).to receive(:locate_space).with(target).and_return(space)

        shooter = Shooter.new(board: Board.new, target: target)

        shooter.fire!
        expect(space).to have_received(:attack!)
      end

      it 'does not allow you to attack invalid coordinates' do
        shooter = Shooter.new(board: Board.new, target: 'A10')

        expect{ shooter.fire! }.to raise_error
      end
    end

    describe '#message' do
      it "returns 'Battleship sunk.' if battleship is sunk" do
        board = double('board')
        space = double('space')
        allow(board).to receive(:locate_space).with('A1').and_return(space)
        allow(space).to receive(:sunk?).and_return(true)

        shooter = Shooter.new(board: board, target: 'A1')

        expect(shooter.message).to eq('Battleship sunk.')

        allow(space).to receive(:sunk?).and_return(false)

        expect(shooter.message).to be_nil
      end
    end
  end
end
