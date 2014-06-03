# -*- coding: utf-8 -*-
feature 'Show and hide tenancy section' do

  before do
    WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  scenario 'select assured', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    expect(page).to have_content("How many tenancy agreements have you had with the defendant?")
  end

  scenario 'select assured, then demoted', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_tenancy_type_demoted')
    expect(page).to_not have_content("How many tenancy agreements have you had with the defendant?")
    expect(page).to have_content("Date of demotion order")
  end

  scenario 'select assured, then demoted, then assured', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_tenancy_type_demoted')
    choose('claim_tenancy_tenancy_type_assured')
    expect(page).to have_content("How many tenancy agreements have you had with the defendant?")
    expect(page).to_not have_content("Date of demotion order")
  end

end
