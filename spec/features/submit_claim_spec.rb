require "spec_helper"

feature "submit claim" do

  def run_scenario index
    data = load_fixture_data(index)
    expected_data = load_expected_data(index)

    AppModel.new(data).exec do
      homepage.visit
      homepage.start_claim
      claim_form.complete_form
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
