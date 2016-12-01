include ShowMeTheCookies

feature 'new submit claim', js: true, slow: true do

  before do
    stub_request(:post, "http://localhost:4000/").to_return(:status => 200, :body => "", :headers => {})
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
    allow_any_instance_of(Courtfinder::Client::HousingPossession).to receive(:get).and_return(court_address)
    Capybara.current_driver = :webkit
  end

  after do
    Capybara.use_default_driver
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
        claim_form.complete_form_with_javascript

        click_button 'Continue'

        expected_name = data['claim']['claimant_1']['full_name']
        puts "I expect page to contain '#{expected_name}'"
        expect(page).to have_content expected_name
        expect(page).to have_content 'You have not yet completed your claim'


        begin
          # raises exception if confirmation page not returned
          page.find(:xpath, '//div[@class="sub-panel summary"]')
        rescue => err
          puts "ERROR: #{err.message} class: #{err.class}"
          fail validation_error_text(page)
        end

        visit('download?flatten=false')
        sleep(2)
        expect(page.driver.response_headers['Content-Type']).to eql 'application/pdf'

        puts 'creating tmp file...'
        pdf_filename = "/tmp/pdf_#{journey}.pdf"
        fl = File.new(pdf_filename, 'w', encoding: 'utf-8')
        fl << page.source.force_encoding("UTF-8")
        fl.close
        puts "...as `#{pdf_filename}`"

        #file = Tempfile.new('pdf_download', encoding: 'utf-8')
        #file.write(page.body.encode("ASCII-8BIT").force_encoding("UTF-8"))

        #file.write(http.body_str.encode("ASCII-8BIT").force_encoding("UTF-8"))

        pdf_filename = fl.path
        pdf.load pdf_filename
        puts "Downloaded pdf returns claimant_1 `#{pdf.generated_values['claimant_1_address']}`"

        expect(pdf.generated_values['claimant_1_address']).to include(data['claim']['claimant_1']['full_name'])

        # pdf.assert_pdf_is_correct(expected_data)
      end
    end
  end
end
