
def fill_in_the_form_correctly
  fill_in 'Name', with: UserCallback::NAME
  fill_in 'Telephone number', with: UserCallback::PHONE
  fill_in "Describe what you'd like to talk about", with: UserCallback::DESCRIPTION

  click_button 'Send'
end


feature 'Callback request' do

  context 'with phone number' do
    let(:expected_url) { remote_test? ? '/accelerated-possession-eviction' : '/' }

    scenario 'request feedback successfully' do
      visit '/ask-for-technical-help'

      fill_in_the_form_correctly

      expect(current_path).to eq expected_url
      expect(page).to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')
    end
  end

  context 'without phone number' do
    let(:expected_url) { remote_test? ? '/accelerated-possession-eviction/user_callback_request' : '/' }

    scenario 'request feedback successfully' do
      visit '/ask-for-technical-help'

      fill_in 'Name', with: UserCallback::NAME
      fill_in 'Telephone number', with: ''
      fill_in "Describe what you'd like to talk about", with: UserCallback::DESCRIPTION

      click_button 'Send'

      expect(current_path).to eq expected_url
      expect(page).to have_content('Please enter a valid phone number.')
    end
  end

  context 'redirect user from the page they came from' do
    let(:expected_url) { remote_test? ? '/accelerated-possession-eviction' : '/' }

    scenario 'go back to form page' do
      visit '/'
      click_link 'Technical help'
      expect(page).to have_content('Ask for technical help')

      fill_in_the_form_correctly

      expect(current_path).to eq expected_url
      expect(page).to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')

    end

    scenario 'go back to form page' do
      visit '/feedback/new'
      click_link 'Technical help'
      expect(page).to have_content('Ask for technical help')

      fill_in_the_form_correctly

      expect(current_path).to eq expected_url
      expect(page).to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')

    end

    scenario 'go back to technical help page' do
      visit '/ask-for-technical-help'
      click_link 'Technical help'
      expect(page).to have_content('Ask for technical help')

      fill_in_the_form_correctly

      expect(current_path).to eq expected_url
      expect(page).to have_content('Thank you we will call you back during the next working day between 9am and 5pm.')

    end
  end
end
