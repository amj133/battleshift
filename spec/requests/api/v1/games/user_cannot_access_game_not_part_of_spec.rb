require 'rails_helper'

describe "if user is not part of game" do
  let(:player_1) { create(:player)}
  let(:player_2) { create(:opponent)}
  let(:game) {
    Game.create(
      player_1: Player.new(Board.new, player_1.api_key),
      player_2: Player.new(Board.new, player_2.api_key)
      )
    }

  it "they cannot access game" do
    user = create(:user)

    headers = { "CONTENT_TYPE" => "application/json", "X-API-KEY" => user.api_key}
    json_payload = {target: "A1"}.to_json

    post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

    expect(response.status).to eq(400)
  end
end
