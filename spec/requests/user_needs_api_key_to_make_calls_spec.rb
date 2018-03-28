require 'rails_helper'

describe "user needs Api key to make calls" do
  it "user does not provide Api key" do
    create(:user)

    post "/api/v1/games"
    unauth_response = JSON.parse(response.body, symbolize_names: true)

    expect(unauth_response[:message]).to eq("Unauthorized")
    expect(response.status).to eq(401)
  end

  it "protects against inactive users" do
    user = create(:user, status: "inactive")

    post "/api/v1/games", :headers => {"X-API-KEY" => user.api_key}
    unauth_response = JSON.parse(response.body, symbolize_names: true)

    expect(unauth_response[:message]).to eq("Unauthorized")
    expect(response.status).to eq(401)
  end
end
