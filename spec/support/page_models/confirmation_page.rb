class ConfirmationPage
  include Capybara::DSL
  include ShowMeTheCookies
  include RSpec::Matchers

  def assert_rendered_pdf(expected_data)
    expected_url = remote_test? ? '/accelerated-possession-eviction/confirmation' : '/confirmation'
    expect(Capybara.current_path).to eql expected_url

    filename = download_pdf

    data_from_rendered_pdf = values_from_pdf(filename)

    expected_data = load_result_data(1)
    expect(data_from_rendered_pdf).to eql expected_data
  end

  def download_pdf
    pdf_filename = ''

    begin
      pdf_filename = capybara_download_pdf
    rescue Capybara::NotSupportedByDriverError, RSpec::Expectations::ExpectationNotMetError
      pdf_filename = visit_download
    end

    pdf_filename
  end

private

  def capybara_download_pdf
    click_link 'Continue'
    assert_pdf_content_type(page.response_headers)

    write_pdf_to_tempfile page.body
  end

  def visit_download
    visit('download?flatten=false')
    sleep 0.1
    assert_pdf_content_type(page.driver.response_headers)
    write_pdf_to_tempfile(page.source, true)
  end

  def write_pdf_to_tempfile(ascii, ignore_8bit_encode=false)
    file = Tempfile.new('pdf_download', encoding: 'utf-8')
    ascii.encode("ASCII-8BIT") unless ignore_8bit_encode
    file.write(ascii.force_encoding("UTF-8"))
    file.path
  end

  def assert_pdf_content_type(headers_hash)
    expect(headers_hash['Content-Type']).to eq "application/pdf"
  end
end
