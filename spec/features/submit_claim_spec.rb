require "spec_helper"

feature "submit claim" do

  def run_scenario index
    data = load_fixture_data(index)
    expected_data = load_expected_data(index)

    app = AppModel.new(data)
    app.claim_form.complete_form
    app.claim_form.submit
    app.confirmation_page.is_displayed?.should be_true, app.claim_form.validation_error_text
    app.pdf.load app.confirmation_page.download_pdf
    
    app.pdf.assert_pdf_is_correct(expected_data)
  end

  Dir.glob('spec/fixtures/scenario_*_data.rb') do |item|
    index = item[/scenario_(\d+)_data/,1].to_i
    data = load_fixture_data(index)
    title = data['title']
    description = data['description']

    eval(%Q|
      scenario "#{title}: #{description.first} (#{description.last})" do
        run_scenario #{index}
      end
    |)
  end

end
