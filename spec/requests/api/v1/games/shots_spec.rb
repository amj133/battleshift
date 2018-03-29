require 'rails_helper'

def place_small_ship(player)
  ShipPlacer.new(board: player.board,
    ship: sm_ship,
    start_space: "A1",
    end_space: "A2").run
  game.save
end

def place_md_ship(player)
  ShipPlacer.new(board: player.board,
    ship: md_ship,
    start_space: "A3",
    end_space: "C3").run
  game.save
end

describe "Api::V1::Shots" do
  context "POST /api/v1/games/:id/shots" do
    let(:sm_ship) { Ship.new(2) }
    let(:md_ship) { Ship.new(3) }
    let(:player_1) { create(:player)}
    let(:player_2) { create(:opponent)}
    let(:game)    {
      Game.create(
        player_1: Player.new(Board.new, player_1.api_key),
        player_2: Player.new(Board.new, player_2.api_key)
      )
    }


    it "updates the message and board with a hit" do
      place_small_ship(game.player_2)

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
      place_small_ship(game.player_2)

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "B1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss."
      player_2_targeted_space = game[:player_2_board][:rows][1][:data].first[:status]

      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Miss")
    end

    it "updates the message and board with a miss when player 2 shoots" do
      place_small_ship(game.player_1)

      game.current_turn = "player_2"
      game.player_1.turns = 1
      game.save!

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "B1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss."
      player_1_targeted_space = game[:player_1_board][:rows][1][:data].first[:status]

      expect(game[:message]).to eq expected_messages
      expect(player_1_targeted_space).to eq("Miss")
    end

    it "updates the message but not the board with invalid coordinates" do
      place_small_ship(game.player_2)

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "B5"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      json_game = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(json_game[:message]).to eq "Invalid coordinates."
      expect(json_game[:id]).to eq(game.id)
    end

    it "displays error message when player sends request and its not their turn" do
      place_small_ship(game.player_2)

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response.status).to eq(400)
      game = JSON.parse(response.body, symbolize_names: true)
      expected_messages = "Invalid move. It's your opponent's turn."

      expect(game[:message]).to eq expected_messages
    end

    it 'displays ship sunk message when a player sinks the opponent ship' do
      place_small_ship(game.player_2)
      place_md_ship(game.player_2)
      place_small_ship(game.player_1)

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A2"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      actual_game = JSON.parse(response.body, symbolize_names: true)

      expect(actual_game[:message]).to eq("Your shot resulted in a Hit. Battleship sunk.")
    end

    it 'displays game over message when a player sinks all of opponents ships' do
      place_small_ship(game.player_2)
      place_md_ship(game.player_2)
      place_small_ship(game.player_1)
      place_md_ship(game.player_1)

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A2"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      actual_game = JSON.parse(response.body, symbolize_names: true)

      expect(actual_game[:message]).to eq("Your shot resulted in a Hit. Battleship sunk.")

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "A2"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "A3"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "A3"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "B3"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "B1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_1.api_key}
      json_payload = {target: "C3"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      actual_game = JSON.parse(response.body, symbolize_names: true)

      expect(actual_game[:message]).to eq("Your shot resulted in a Hit. Battleship sunk. Game over.")
      expect(actual_game[:winner]).to eq(player_1.email)

      headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => player_2.api_key}
      json_payload = {target: "B1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response.status).to eq(400)

      actual_game = JSON.parse(response.body, symbolize_names: true)

      expect(actual_game[:message]).to eq("Invalid move. Game over.")
      expect(actual_game[:winner]).to eq(player_1.email)
    end
  end
end
