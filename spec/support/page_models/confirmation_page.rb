class ConfirmationPage
  include Capybara::DSL

  def initialize(data)
    @data = data['claim']
    visit '/confirmation'
  end

  def is_displayed?
    page.has_text?('You now need to send the completed form and documents to the court to make your claim')
  end

  def download_pdf
      page.evaluate_script("window.jQuery('a.pdf-download').removeAttr('target')")
      click_link 'Print completed form'
      expect(page.response_headers['Content-Type']).to eq "application/pdf"

      # todo: use curl to download the PDF
      # parse the PDF
      # assertions


      # generated_file = '/tmp/a.pdf'
      # File.open(generated_file, 'w') { |file| file.write(page.body.encode("ASCII-8BIT").force_encoding("UTF-8")) }

      # generated_values = values_from_pdf generated_file

      # expected_values.each do |field, value|
      #   "#{field}: #{generated_values[field]}".should == "#{field}: #{value}"
      # end

  end
end