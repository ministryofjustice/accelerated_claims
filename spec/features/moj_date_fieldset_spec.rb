feature "moj date fieldset" do

  before do
    stub_request(:post, "http://localhost:4000/").
      to_return(:status => 200, :body => "", :headers => {})

     WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  context 'without javascript' do
    unless remote_test?
      scenario "user types 13 01 2014" do
        data = load_fixture_data(1)
        data['claim']['notice']['date_served'] = '2014-01-13'
        expected_data = load_expected_data(1)
        run_scenario(data, expected_data, js: false)
      end
    end
  end

  context 'with javascript' do
    scenario "user types 13 01 2014", js: true  do
      data = load_fixture_data(1)
      data['claim']['notice']['date_served'] = '2014-01-13'
      expected_data = load_expected_data(1)
      run_scenario(data, expected_data, js: true)
    end
  end




  def run_scenario(data, expected_data, options)
    # data = load_fixture_data(1)
    # expected_data = load_expected_data(1)


    AppModel.new(data).exec do
      homepage.visit
      homepage.start_claim
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

  

  # unless remote_test?
  #   scenario "Test moj_date_fieldset: 2014-08-14 regular two digit month and day" do
  #     data = load_fixture_data(1)
  #     expected_data = load_expected_data(1)
  #     run_scenario(data, expected_data, js: false)
  #   end
  # end

  # scenario "Test moj_date_fieldset: 2014-08-14 regular two digit month and day", js: true  do
  #   run_scenario(1, js: true)
  # end



end
