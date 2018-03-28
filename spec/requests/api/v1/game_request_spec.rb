require 'rails_helper'

describe "post /api/v1/game" do
  it "creates a new game" do
    user = create(:user)

    post "/api/v1/games", :headers => {"X-API-KEY" => user.api_key}

    actual_game = JSON.parse(response.body, symbolize_names: true)
    expected_game = Game.last

    expect(expected_game.id).to eq(actual_game[:id])
  end
end
