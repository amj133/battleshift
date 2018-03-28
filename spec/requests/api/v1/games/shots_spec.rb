require 'rails_helper'

describe "Api::V1::Shots" do
  context "POST /api/v1/games/:id/shots" do
    let(:player_1_board)   { Board.new(4) }
    let(:player_2_board)   { Board.new(4) }
    let(:sm_ship) { Ship.new(2) }
    let(:player_1) { create(:player)}
    let(:player_2) { create(:opponent)}
    let(:game)    {
      create(:game,
        player_1_board: player_1_board,
        player_2_board: player_2_board,
        player_1: player_1.api_key,
        player_2: player_2.api_key
      )
    }

    it "updates the message and board with a hit" do
      ShipPlacer.new(board: player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]

      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Hit")
    end

    it "updates the message and board with a miss when player 1 shoots" do
      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]

      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Miss")
    end

    it "updates the message and board with a miss when player 2 shoots" do
      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss."
      player_1_targeted_space = game[:player_1_board][:rows].first[:data].first[:status]

      expect(game[:message]).to eq expected_messages
      expect(player_1_targeted_space).to eq("Miss")
    end

    it "updates the message but not the board with invalid coordinates" do
      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "B5"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      game = JSON.parse(response.body, symbolize_names: true)
      expect(game[:message]).to eq "Invalid coordinates."
    end

    it "displays error message when player sends request and its not their turn" do
      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success
      game = JSON.parse(response.body, symbolize_names: true)
      expected_messages = "Invalid move. It's your opponent's turn."

      expect(game[:message]).to eq expected_messages
    end
  end
end
