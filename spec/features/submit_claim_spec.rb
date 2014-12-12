feature "submit claim" do

  before do
    stub_request(:post, "http://localhost:4000/").to_return(:status => 200, :body => "", :headers => {})
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
    allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
      receive(:get).and_return(court_address.to_json)
  end

  def run_scenario data_file, options={}
    data = load_fixture_data(data_file)
    expected_summary_data = load_expected_data(data_file)
    expected_data = load_expected_data(data_file)

    AppModel.new(data).exec do
      visit '?test=true'

      if options[:js]
        claim_form.complete_form_with_javascript
      else
        claim_form.complete_form
      end

      click_button 'Continue'

      begin
        # raises exception if confirmation page not returned
        page.find(:xpath, '//*[@id="content"]/section[1]')
      rescue => err
        puts "ERROR: #{err.message} class: #{err.class}"
        fail validation_error_text(page)
      end

      summary_values = find_summary_values page, data_file
      summary_values.delete(:claim_property_use_live_postcode_lookup)
      expected_summary_values = load_expected_summary_values data_file

      expect(summary_values.size).to eq(expected_summary_values.size),
          "Expected #{expected_summary_values.size} summary fields on summary page,
          got #{summary_values.size} summary fields,
          difference: #{(expected_summary_values.keys - summary_values.keys).size > 0 ?
            (expected_summary_values.keys - summary_values.keys) :
            (summary_values.keys - expected_summary_values.keys) }".squeeze(' ')

      expected_summary_values.each do |key, values|
        if ENV["env"] == 'production'
          (expect(['Postcode', 'SW1H9AJ']).to eq(values)) if key == 'claim_property_postcode'
        else
          expect(summary_values[key]).to eq(values),
           "#{key} field on summary page expected:\n  #{values}\ngot:\n  #{summary_values[key]}"
        end
      end

      if Capybara.default_driver == :browserstack
        find('a#data').click

        body = page.body.split('">').last.split('<pre>').last.split('</pre>').first
        json = JSON.parse(body)

        expected_data.each do |field, value|
          generated = json[field].to_s.gsub("\r\n","\n").strip
          expect("#{field}: #{generated}").to eq("#{field}: #{value}")
        end
      else
        pdf_filename = confirmation_page.download_pdf
        pdf.load pdf_filename
        if(ENV.key? 'save_pdf')
          File.rename(pdf_filename, "spec/fixtures/pdfs/scenario_#{index}.pdf")
          write_hash_to_file("spec/fixtures/scenario_#{index}_results.rb", pdf.generated_values)
        else
          pdf.assert_pdf_is_correct(expected_data)
        end
      end
    end
  end

  JOURNEY = ENV['JOURNEY'] || ''

  Dir.glob("spec/fixtures/scenario_#{JOURNEY}*_data.rb") do |data_file|
    data = load_fixture_data(data_file)
    title = data['title']
    description = data['description']

    unless remote_test? || ENV['browser']
      unless data['javascript'] == 'JS'
        eval(%Q|
          scenario "#{title}: #{description.first} (#{description.last})" do
            # require 'ruby-prof'
            # RubyProf.start
            run_scenario '#{data_file}', js: false
            # result = RubyProf.stop
#
            # printer = RubyProf::FlatPrinter.new(result)
            # printer.print(STDOUT)
          end
        |)
      end
    end

    unless data['javascript'] == 'NON-JS'
      eval(%Q|
        scenario "#{title} with JS: #{description.first} (#{description.last})", js: true do
          run_scenario '#{data_file}', js: true
        end
      |)
    end
  end
end
