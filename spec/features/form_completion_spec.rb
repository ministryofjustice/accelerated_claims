require 'spec_helper'

feature 'Filling in claim form' do

  scenario "submitting incomplete form" do
    visit '/'
    click_button 'Complete form'
    expect(page).to have_content("Street can't be blank")

    # expect(page).to have_content("Notice served by can't be blank")
  end

end
