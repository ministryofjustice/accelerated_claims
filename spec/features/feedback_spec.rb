feature 'Providing feedback' do

  context 'with email' do
    scenario "submitting feedback successfully" do
      visit '/'
      click_link 'your feedback'

      fill_in 'Your comments', with: 'Some comments'
      fill_in 'Your email address', with: '@bad_address'

      click_button 'Send'

      expect(page).to have_content('is not a valid address')
      fill_in 'Your email address', with: 'test@example.com'

      click_button 'Send'

      expect(page).to have_content('Thanks for your feedback.')
    end
  end

  context 'without email' do
    scenario "submitting feedback successfully" do
      visit '/'
      click_link 'your feedback'

      fill_in 'Your comments', with: 'Some comments'
      fill_in 'Your email address', with: ''

      click_button 'Send'

      expect(page).to have_content('Thanks for your feedback.')
    end
  end

end
