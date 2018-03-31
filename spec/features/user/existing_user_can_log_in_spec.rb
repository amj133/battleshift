require 'rails_helper'

describe "existing user visits root" do
  context "clicks sign in" do
    before(:all) do
      create(:user)
    end

    it "and successfully logs in to dashboard" do
      visit "/"

      click_on "Sign in"

      expect(current_path).to eq("/login")

      fill_in "name", with: "Sam"
      fill_in "password", with: "test1"
      click_on "Sign in"

      expect(current_path).to eq("/dashboard")
      expect(page).to have_content("Welcome Sam. Prepare for battle...ship.")
    end

    it "stays on login page with incorrect credentials" do
      visit "/login"

      fill_in "name", with: "Sam"
      fill_in "password", with: "wrong"
      click_on "Sign in"

      expect(current_path).to eq("/login")
      expect(page).to have_content("Incorrect credentials")
    end
  end
end
