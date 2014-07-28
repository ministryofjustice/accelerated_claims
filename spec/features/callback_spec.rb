feature 'Callback request' do

  context 'with phone number' do
    scenario 'request feedback successfully' do
      visit '/ask-for-technical-help'

      fill_in 'Name', with: UserCallback::NAME
      fill_in 'Telephone number', with: UserCallback::PHONE
      fill_in "Describe what you'd like to talk about", with: UserCallback::DESCRIPTION

      click_button 'Send'

      expect(page).to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')
    end
  end

  context 'without phone number' do
    scenario 'request feedback successfully' do
      visit '/ask-for-technical-help'

      fill_in 'Name', with: UserCallback::NAME
      fill_in 'Telephone number', with: ''
      fill_in "Describe what you'd like to talk about", with: UserCallback::DESCRIPTION

      click_button 'Send'

      expect(page).to have_content('Please enter a valid phone number.')
    end
  end
end
