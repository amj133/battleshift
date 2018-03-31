require 'rails_helper'

describe Player do
  context 'attributes' do
    subject { Player.new(Board.new, "khadkjhfk0398") }

    it 'has a board, turns, and api_key' do
      expect(subject.board.class).to eq(Board)
      expect(subject.turns).to eq(0)
      expect(subject.api_key.class).to eq(String)
    end

    it "board can be written to" do
      subject.board = "updated_board"

      expect(subject.board).to eq("updated_board")
    end

    it "turns can be writtent to" do
      subject.turns = 5

      expect(subject.turns).to eq(5)
    end
  end
end
