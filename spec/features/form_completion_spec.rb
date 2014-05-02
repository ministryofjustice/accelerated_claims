feature 'Filling in claim form' do

  before do
    WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  scenario "submitting incomplete form", js: false do
    visit '/new'
    click_button 'Complete form'
    expect(page).to have_content("Street must be entered")

    expect(page).to have_content("Served by name must be entered")

    expect(page).to have_content("Served method must be entered")

    expect(page).to have_content("House must be selected")
  end

  scenario "submitting incomplete form", js: true do
    visit '/new'
    click_button 'Complete form'

    expect(page).to have_content(%Q|Question "As the landlord, you're known as the claimant in this case. How many claimants are there?" not answered|)
    expect(page).to have_content(%Q|Question "Your tenants are known as defendants in this case. How many defendants are there?" not answered|)
  end

end
