feature 'Providing feedback' do

  def comments_text
    comments = remote_test? ? Feedback::TEST_TEXT : 'Some comments'
  end

  context 'with email' do
    scenario "submitting feedback successfully" do
      visit '/'
      click_link 'your feedback'

      fill_in 'Did you have any difficulty with this service?', with: comments_text
      fill_in 'Your email address', with: '@bad_address'

      click_button 'Send'

      expect(page).to have_content('Enter a valid email address')
      fill_in 'Your email address', with: 'test@example.com'

      click_button 'Send'

      expect(page).to have_content('Thanks for your feedback.')
    end
  end

  context 'without email' do
    scenario "submitting feedback successfully" do
      visit '/'
      click_link 'your feedback'

      fill_in 'Did you have any difficulty with this service?', with: comments_text
      fill_in 'Your email address', with: ''

      click_button 'Send'

      expect(page).to have_content('Thanks for your feedback.')
    end
  end

end
