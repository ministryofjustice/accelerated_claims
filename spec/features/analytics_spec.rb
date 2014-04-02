require 'spec_helper'

feature 'analytics configuration', :remote => true do
  scenario 'piwik cookies are set' do
    visit '/'
    expect(get_me_the_cookie '_pk_id').to_not be_nil
  end
end