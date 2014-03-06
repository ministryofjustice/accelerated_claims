require 'spec_helper'

feature 'Providing feedback' do

  scenario "submitting feedback successfully" do
    visit '/'
    click_link 'your feedback'

    expect(page).to have_content("")
    expect(page).to have_content("Your email address")

    fill_in 'Your comments', with: 'Some comments'
    fill_in 'Your email address', with: '@bad_address'

    click_button 'Send'

    expect(page).to have_content('is not a valid address')
    fill_in 'Your email address', with: 'test@example.com'

    click_button 'Send'

  end

end
