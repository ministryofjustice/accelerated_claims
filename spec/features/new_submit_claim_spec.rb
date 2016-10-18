include ShowMeTheCookies

feature 'new submit claim', js: true do

  before do
    FileUtils.rm_rf(Dir['tmp/capybara/[^.]*'])
    FileUtils.rm_rf(Dir['/tmp/accelerated_claim*'])
    FileUtils.rm_rf(Dir['/tmp/pdf_download*'])
    stub_request(:post, "http://localhost:4000/").to_return(:status => 200, :body => "", :headers => {})
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
    allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
    receive(:get).and_return(court_address)
    Capybara.current_driver = :poltergeist
  end

  after do
    Capybara.use_default_driver
    # Capybara.delete_cookie('_accelerated_claims_session')
    # Capybara.reset_sessions!
    # Rails.cache.clear
    # browser = Capybara.current_session.driver.browser
    # if browser.respond_to?(:clear_cookies)
    #   # Rack::MockSession
    #   puts '# Rack::MockSession'
    #   browser.clear_cookies
    # elsif browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
    #   # Selenium::WebDriver
    #   puts '# Selenium::WebDriver'
    #   browser.manage.delete_all_cookies
    # else
    #   raise "Don't know how to clear cookies. Weird driver?"
    # end
  end

  %w[01 02].each do |journey|

    data_file = "spec/fixtures/scenario_#{journey}_js_data.rb"
    data = load_fixture_data(data_file)
    title = data['title']
    description = data['description']

    scenario "#{title} with JS: #{description.first} (#{description.last})", js: true do
      data = load_fixture_data(data_file)

      AppModel.new(data).exec do
        expect(pdf.generated_values).to be nil
        visit "?test=true&#{rand(30)}"
        page.driver.clear_cookies
        page.driver.clear_memory_cache;
        claim_form.complete_form_with_javascript

        click_button 'Continue'

        expected_name = data['claim']['claimant_1']['full_name']
        puts "I expect page to contain '#{expected_name}'"
        expect(page).to have_content expected_name


        begin
          # raises exception if confirmation page not returned
          page.find(:xpath, '//div[@class="sub-panel summary"]')
        rescue => err
          puts "ERROR: #{err.message} class: #{err.class}"
          fail validation_error_text(page)
        end

        download_url = Capybara.current_url.gsub(/confirmation$/, 'download?flatten=false')
        cookie_id = '_accelerated_claims_session'
        session_id = get_me_the_cookie(cookie_id)[:value]
        cookie = "#{cookie_id}=#{session_id}"
        puts "--setting cookie to #{cookie}"

        http = Curl.get(download_url) do |http|
          http.headers['Cookie'] = cookie
          http.ssl_verify_peer = false
          http.ssl_verify_host = false
          http.follow_location = true
        end

        *http_headers = http.header_str.split(/[\r\n]+/).map(&:strip)
        http_headers = Hash[http_headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]

        expect(http_headers['Content-Type']).to eq "application/pdf"

        file = Tempfile.new('pdf_download', encoding: 'utf-8')
        file.write(http.body_str.encode("ASCII-8BIT").force_encoding("UTF-8"))

        pdf_filename = file.path
        puts "saving downloaded data to `#{pdf_filename}`"
        pdf.load pdf_filename
        puts "Downloaded pdf returns claimant_1 `#{pdf.generated_values['claimant_1_address']}`"

        expect(pdf.generated_values['claimant_1_address']).to include(data['claim']['claimant_1']['full_name'])

        # pdf.assert_pdf_is_correct(expected_data)
      end
    end
  end
end
