feature "submit claim" do

  before do
    stub_request(:post, "http://localhost:4000/").
      to_return(:status => 200, :body => "", :headers => {})

     WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  def run_scenario data_file, options={}
    data = load_fixture_data(data_file)
    expected_data = load_expected_data(data_file)

    AppModel.new(data).exec do
      homepage.visit
      if options[:js]
        claim_form.complete_form_with_javascript
      else
        claim_form.complete_form
      end
      claim_form.submit

      confirmation_page.is_displayed?.should be_true, claim_form.validation_error_text

      pdf_filename = confirmation_page.download_pdf
      pdf.load pdf_filename
      if(ENV.key? 'save_pdf')
        File.rename(pdf_filename, "spec/fixtures/pdfs/scenario_#{index}.pdf")
        pdf.write_hash_to_file("spec/fixtures/scenario_#{index}_results.rb")
      else
        pdf.assert_pdf_is_correct(expected_data)
      end
    end
  end

  Dir.glob('spec/fixtures/scenario_01_*_data.rb') do |data_file|
    data = load_fixture_data(data_file)
    title = data['title']
    description = data['description']

    puts "++++++ DEBUG processing file #{data_file} ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    

    # unless remote_test?
    #   unless data['javascript'] == 'JS'
    #     puts "++++++ DEBUG data['javascript'] #{data['javascript'].inspect}   NO JS ++++++ #{__FILE__}::#{__LINE__} ++++\n"
        
    #     eval(%Q|
    #       scenario "#{title}: #{description.first} (#{description.last})" do
    #         run_scenario '#{data_file}', js: false
    #       end
    #     |)
    #   end
    # end

    unless data['javascript'] == 'NON-JS'

      puts "++++++ DEBUG data['javascript'] #{data['javascript'].inspect}   with JS ++++++ #{__FILE__}::#{__LINE__} ++++\n"
      
      eval(%Q|
        scenario "#{title} with JS: #{description.first} (#{description.last})", js: true do
          run_scenario '#{data_file}', js: true
        end
      |)
    end
  end

end
