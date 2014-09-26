feature 'Session timeout' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

  if remote_test?
    scenario "extend session dialog shown before session expires", js: true do
      using_wait_time(10) do
        start = Time.now
        visit '/?quick=very' # this causes extend session dialog to show after 3 secs
        expect(page).to have_content('Your session will expire')
        seconds_since_page_opened = Time.now - start

        expect(seconds_since_page_opened).to be > 3
        expect(current_url).to_not include('/expired')
      end
    end

    scenario "session expires if you wait long enough", js: true do
      using_wait_time(20) do
        start = Time.now
        visit '/?quick=very' # this causes client session to expire in 9 secs
        expect(page).to have_content('Session expired')
        seconds_since_page_opened = Time.now - start

        expect(seconds_since_page_opened).to be > 9
        expect(current_url).to include('/expired')
      end
    end
  end

end
