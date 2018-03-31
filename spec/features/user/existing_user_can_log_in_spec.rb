require 'rails_helper'

describe "existing user visits root" do
  context "clicks sign in" do
    let(:user) { create(:user) }

    it "and successfully logs in to dashboard" do
      visit "/"

      click_on "Sign In"

      expect(current_path).to eq("/login")

      fills_in "name", with: "Sam"
      fills_in "password", with: "test1"

      click_on "Sign In"

      expect(current_path).to eq("/dashboard")
      expect(page).to have_content("Welcome Sam - Prepare for battle...ship.")
    end
  end
end
