feature 'Filling in claim form' do

  scenario "submitting incomplete form" do
    visit '/new'
    click_button 'Complete form'
    expect(page).to have_content("Street must be entered")

    expect(page).to have_content("Served by name must be entered")

    expect(page).to have_content("Served method must be entered")

    expect(page).to have_content("House must be selected")
  end

end
