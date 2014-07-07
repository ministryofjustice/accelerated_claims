feature 'Callback request' do

  context 'with phone number' do
    scenario 'request feedback successfully' do
      visit '/user_callback/new'

      fill_in 'Name', with: 'Bob'
      fill_in 'Telephone number', with: '02077778888'
      fill_in 'Details', with: 'Call me please, this internet thing is not for me!'

      click_button 'Send'

      expect(page).to have_content('Thank you, we\'ll call you.')
    end
  end

  context 'without phone number' do
    scenario 'request feedback successfully' do
      visit '/user_callback/new'

      fill_in 'Name', with: 'Bob'
      fill_in 'Telephone number', with: ''
      fill_in 'Details', with: 'Call me please, this internet thing is not for me!'

      click_button 'Send'

      expect(page).to have_content('can\'t be blank')
    end
  end
end
