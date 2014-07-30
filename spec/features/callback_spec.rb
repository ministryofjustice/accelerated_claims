
def fill_in_the_form_correctly
  fill_in 'Name', with: UserCallback::NAME
  fill_in 'Telephone number', with: UserCallback::PHONE
  fill_in "Describe what you'd like to talk about", with: UserCallback::DESCRIPTION

  click_button 'Send'
end


feature 'Callback request' do

  context 'with phone number' do
    scenario 'request feedback successfully' do
      visit '/ask-for-technical-help'

      fill_in_the_form_correctly

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

  context 'redirect user from the page they came from' do
    scenario 'go back to form page' do
      visit '/'
      click_link 'Technical help'
      expect(page).to have_content('Ask for technical help')

      fill_in_the_form_correctly

      expect(page).to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')
      expect(current_path).to eq '/'
    end

    scenario 'go back to form page' do
      visit '/feedback/new'
      click_link 'Technical help'
      expect(page).to have_content('Ask for technical help')

      fill_in_the_form_correctly

      expect(page).not_to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')

      expect(current_path).to eq '/feedback/new'
    end

    scenario 'go back to technical help page' do
      visit '/ask-for-technical-help'
      click_link 'Technical help'
      expect(page).to have_content('Ask for technical help')

      fill_in_the_form_correctly

      expect(page).to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')

      expect(current_path).to eq '/ask-for-technical-help'
    end
  end
end
