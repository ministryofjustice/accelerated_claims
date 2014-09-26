# -*- coding: utf-8 -*-
feature 'Filling in claim form' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

  unless remote_test?
    scenario "all error messages appear in a label or a legend", js: false do
      visit '/'
      click_button 'Continue'
      expect(page).to_not have_xpath("//span[contains(@class, 'error') and not(parent::label | parent::legend)]")
    end
  end


end
