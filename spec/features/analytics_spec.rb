feature 'analytics configuration', :remote => true do
  scenario 'Piwik analytics cookies are set' do
    visit '/'
    found_piwik_id_cookie = false
    get_me_the_cookies.each do |cookie|
      found_piwik_id_cookie = true if(cookie[:name] =~ /^_pk_id/)
    end
    expect(found_piwik_id_cookie).to be_true
  end

  scenario 'Google analytics cookies are set' do
    visit '/'
    expect(get_me_the_cookie '_ga').to_not be_nil
  end
end