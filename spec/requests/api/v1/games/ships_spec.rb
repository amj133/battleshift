require 'rails_helper'

describe "Api::V1::Ships" do
  context 'POST /api/v1/games/:id/ships' do
    let(:player_1_board)   { Board.new }
    let(:player_2_board)   { Board.new }
    let(:sm_ship) { Ship.new(2) }
    let(:game)    {
      create(:game,
        player_1_board: player_1_board,
        player_2_board: player_2_board
      )
    }
    it "updates the contents of the spaces on the board" do
      user = create(:user)
      ship_1_payload = {
                          ship_size: 3,
                          start_space: "A1",
                          end_space: "A3"
                        }

      post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, :headers => {"X-API-KEY" => user.api_key}

      game = Game.last
      game_response = JSON.parse(response.body, symbolize_names: true)
      expected_messages = "Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2."

      expect(game_response[:id]).to eq(game.id)
      expect(game_response[:message]).to eq expected_messages
      expect(game.player_1_board.board.first.first.values.first.contents.class).to eq(Ship)
    end
  end
end
