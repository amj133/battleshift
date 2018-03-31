require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:player_1) { "challenger" }
  let(:player_2) { "opponent" }
  subject {
    Game.new(player_1: player_1,
             player_2: player_2)
  }

  describe "validations" do
    it {should validate_presence_of(:player_1)}
    it {should validate_presence_of(:player_2)}
  end

  describe "current_turn" do
    it "can be set to player 1 or player 2" do
      subject.current_turn = 0

      expect(subject.current_turn).to eq("player_1")

      subject.current_turn = 1

      expect(subject.current_turn).to eq("player_2")
    end
  end
end
