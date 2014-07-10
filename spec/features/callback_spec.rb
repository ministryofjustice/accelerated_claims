feature 'Callback request' do

  context 'with phone number' do
    scenario 'request feedback successfully' do
      visit '/ask-for-technical-help'

      fill_in 'Name', with: 'Bob'
      fill_in 'Telephone number', with: '02077778888'
      fill_in "Describe what you'd like to talk about", with: 'Call me please, this internet thing is not for me!'

      click_button 'Send'

      expect(page).to have_content('Thank you we will call you back within 24 hours between 9am and 5pm.')
    end
  end

  context 'without phone number' do
    scenario 'request feedback successfully' do
      visit '/ask-for-technical-help'

      fill_in 'Name', with: 'Bob'
      fill_in 'Telephone number', with: ''
      fill_in "Describe what you'd like to talk about", with: 'Call me please, this internet thing is not for me!'

      click_button 'Send'

      expect(page).to have_content('can\'t be blank')
    end
  end
end
