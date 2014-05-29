feature 'analytics configuration', :remote => true do
  scenario 'Google analytics cookies are set' do
    visit '/?anim=false'
    expect(get_me_the_cookie '_ga').to_not be_nil
  end
end