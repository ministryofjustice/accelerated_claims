feature "moj date fieldset" do

  before do
    stub_request(:post, "http://localhost:4000/").
      to_return(:status => 200, :body => "", :headers => {})

     WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  context 'without javascript' do
    unless remote_test?
      scenario "user types two digit numeric day two digit numeric month: 13 01 2014" do
        data, expected_data = update_data_and_results('2014-01-13')
        run_scenario(data, expected_data, js: false)
      end

      scenario "user types two digit numeric day one digit numeric month: 13 1 2014" do
        data, expected_data = update_data_and_results('2014-1-13')
        run_scenario(data, expected_data, js: false)
      end

      scenario "user types two digit numeric day, month name in lower case: 13 january 2014" do
        data, expected_data = update_data_and_results('2014-january-13')
        run_scenario(data, expected_data, js: false)
      end

      scenario "user types two digit numeric day, abbreviated month name in lower case:  13 jan 2014" do
        data, expected_data = update_data_and_results('2014-jan-13')
        run_scenario(data, expected_data, js: false)
      end

      scenario "user types two digit numeric day, abbreviated month name in mixed case:  13 JAn 2014" do
        data, expected_data = update_data_and_results('2014-JAn-13')
        run_scenario(data, expected_data, js: false)
      end

      scenario "user types one digit numeric day, abbreviated month name in mixed case: 1 JAn 2014" do
        data, expected_data = update_data_and_results('2014-JAn-1', notice_date_served_day: '01')
        run_scenario(data, expected_data, js: false)
      end

      scenario "user types one digit day, one digit month: 1 1 2014" do
        data, expected_data = update_data_and_results('2014-1-1', notice_date_served_day: '01')
        run_scenario(data, expected_data, js: false)
      end

      scenario 'user types 29 Feb 2012 - which is OK because its a leap year' do
        data, expected_data = update_data_and_results('2012-Feb-29', notice_date_served_day: '29', notice_date_served_month: '02', notice_date_served_year: '2012')
        run_scenario(data, expected_data, js: false)
      end

      scenario 'user types 29 02 2014 - which is an invalid day number for Feb' do
        data, expected_data = update_data_and_results('2014-02-29')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
      end

      scenario 'user types invalid day number for January: 33 01 2014' do
        data, expected_data = update_data_and_results('2014-01-33')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
      end

      scenario 'user types invalid day number for april: 31 APRIL 2014'  do
        data, expected_data = update_data_and_results('2014-April-31')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
      end      


      scenario 'user types invalid month name:  15-avgust-2014' do 
        data, expected_data = update_data_and_results('2012-avgust-15')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
      end

      scenario 'user types invalid month number: 3-15-2014' do 
        data, expected_data = update_data_and_results('2012-15-3')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
      end     

      scenario 'user omits day' do  
        data, expected_data = update_data_and_results('2012-15- ')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
      end

      scenario 'user omits month' do
        data, expected_data = update_data_and_results('2012--3')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
      end

      scenario 'user omits year' do
        data, expected_data = update_data_and_results(' -1-3')
        expect {
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
      end

      scenario 'user specifies two digit year' do
        expect {
          data, expected_data = update_data_and_results('14-1-1', notice_date_served_day: '01')
          run_scenario(data, expected_data, js: false)
        }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
      end

    end
  end


  context 'with javascript' do
    scenario "user types two digit numeric day two digit numeric month: 13 01 2014", js: true do
      data, expected_data = update_data_and_results('2014-01-13')
      run_scenario(data, expected_data, js: true)
    end

    scenario "user types two digit numeric day one digit numeric month: 13 1 2014", js: true do
      data, expected_data = update_data_and_results('2014-1-13')
      run_scenario(data, expected_data, js: true)
    end

    scenario "user types two digit numeric day, month name in lower case: 13 january 2014", js: true do
      data, expected_data = update_data_and_results('2014-january-13')
      run_scenario(data, expected_data, js: true)
    end

    scenario "user types two digit numeric day, abbreviated month name in lower case:  13 jan 2014", js: true do
      data, expected_data = update_data_and_results('2014-jan-13')
      run_scenario(data, expected_data, js: true)
    end

    scenario "user types two digit numeric day, abbreviated month name in mixed case:  13 JAn 2014", js: true do
      data, expected_data = update_data_and_results('2014-JAn-13')
      run_scenario(data, expected_data, js: true)
    end

    scenario "user types one digit numeric day, abbreviated month name in mixed case: 1 JAn 2014", js: true do
      data, expected_data = update_data_and_results('2014-JAn-1', notice_date_served_day: '01')
      run_scenario(data, expected_data, js: true)
    end

    scenario "user types one digit day, one digit month: 1 1 2014", js: true do
      data, expected_data = update_data_and_results('2014-1-1', notice_date_served_day: '01')
      run_scenario(data, expected_data, js: true)
    end

    scenario 'user types 29 Feb 2012 - which is OK because its a leap year', js: true do
      data, expected_data = update_data_and_results('2012-Feb-29', notice_date_served_day: '29', notice_date_served_month: '02', notice_date_served_year: '2012')
      run_scenario(data, expected_data, js: true)
    end

    scenario 'user types 29 02 2014 - which is an invalid day number for Feb', js: true do
      data, expected_data = update_data_and_results('2014-02-29')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
    end

    scenario 'user types invalid day number for January: 33 01 2014', js: true do
      data, expected_data = update_data_and_results('2014-01-33')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
    end

    scenario 'user types invalid day number for april: 31 APRIL 2014', js: true  do
      data, expected_data = update_data_and_results('2014-April-31')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
    end      


    scenario 'user types invalid month name:  15-avgust-2014', js: true do 
      data, expected_data = update_data_and_results('2012-avgust-15')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
    end

    scenario 'user types invalid month number: 3-15-2014', js: true do 
      data, expected_data = update_data_and_results('2012-15-3')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served is invalid date: #claim_notice_date_served_error" 
    end     

    scenario 'user omits day', js: true do  
      data, expected_data = update_data_and_results('2012-15- ')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
    end

    scenario 'user omits month', js: true do
      data, expected_data = update_data_and_results('2012--3')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
    end

    scenario 'user omits year', js: true do
      data, expected_data = update_data_and_results(' -1-3')
      expect {
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
    end

    scenario 'user specifies two digit year', js: true do
      expect {
        data, expected_data = update_data_and_results('14-1-1', notice_date_served_day: '01')
        run_scenario(data, expected_data, js: true)
      }.to raise_error RSpec::Expectations::ExpectationNotMetError, "Validation Errors:\n\tDate served must be entered: #claim_notice_date_served_error" 
    end

  end



  def update_data_and_results(date_string, result_fields = {})
    data = load_fixture_data(1)
    data['claim']['notice']['date_served'] = date_string
    expected_data = load_expected_data(1)
    result_fields.each do |field, new_value|
      expected_data[field.to_s] = new_value
    end
    [data, expected_data]
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
