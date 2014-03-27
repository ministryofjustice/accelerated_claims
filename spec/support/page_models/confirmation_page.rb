class ConfirmationPage
  include Capybara::DSL
  include ShowMeTheCookies
  include RSpec::Matchers

  def initialize(data)
    #@data = data['claim']
    # '/confirmation'
  end

  def is_displayed?
    page.has_text?('You now need to send the completed form and documents to the court to make your claim')
  end

  def download_pdf


    pdf_filename = case Capybara.app_host.blank?
    when true
      capybara_download_pdf
    else
      curl_download_pdf
    end

  end

private
  def capybara_download_pdf
    expect(Capybara.current_path).to eql "/confirmation"
    click_link 'Print completed form'
    assert_pdf_content_type(page.response_headers)
    
    write_pdf_to_tempfile page.body
  end

  def curl_download_pdf
    cookie_id = '_accelerated_claims_session'
    session_id = get_me_the_cookie(cookie_id)[:value]

    http = Curl.get(Capybara.app_host + "/download") do |http|
      http.headers['Cookie'] = "#{cookie_id}=#{session_id}"
      http.ssl_verify_peer = false
      http.ssl_verify_host = false
      http.follow_location = true
    end

    assert_pdf_content_type(parse_headers http.header_str)
    write_pdf_to_tempfile http.body_str
  end

  def write_pdf_to_tempfile(ascii)
    file = Tempfile.new('pdf_download', encoding: 'utf-8')
    file.write(ascii.encode("ASCII-8BIT").force_encoding("UTF-8"))
    file.path
  end

  def assert_pdf_content_type(headers_hash)
    expect(headers_hash['Content-Type']).to eq "application/pdf"
  end

  def parse_headers(curl_header_string)
    http_response, *http_headers = curl_header_string.split(/[\r\n]+/).map(&:strip)
    http_headers = Hash[http_headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]
  end
end