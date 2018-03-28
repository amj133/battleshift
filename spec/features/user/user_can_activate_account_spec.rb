require 'rails_helper'

describe 'As a user' do
  context 'when I visit activate account link' do
    scenario 'I see a thank you page and my account is activated' do
      user = create(:user, status: 'inactive')

      visit activate_path(user)

      expect(page).to have_content('Thank you! Your account is now activated.')

      visit dashboard_path

      expect(page).to have_content('Status: Active')
    end
  end
end
