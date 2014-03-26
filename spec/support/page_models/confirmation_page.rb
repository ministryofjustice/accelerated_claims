class ConfirmationPage
  include Capybara::DSL
  include ShowMeTheCookies
  include RSpec::Matchers

  def initialize(data)
    #@data = data['claim']
    # '/confirmation'
  end

  def is_displayed?
    save_and_open_page
    page.has_text?('You now need to send the completed form and documents to the court to make your claim')
  end

  def download_pdf

      # not all Capybara drivers implement these methods
      # if page.respond_to? :evaluate_script && page.respond_to? :response_headers
      #   page.evaluate_script("window.jQuery('a.pdf-download').removeAttr('target')")
      #   click_link 'Print completed form'
      #   expect(page.response_headers['Content-Type']).to eq "application/pdf"
      # end

      cookie_id = '_accelerated_claims_session'
      session_id = get_me_the_cookie(cookie_id)[:value]

      url = Capybara.app_host.blank? ? "http://localhost:#{Capybara.server_port}" : Capybara.app_host
      url += "/download"

      http = Curl.get(url) do |http|
        http.headers['Cookie'] = "#{cookie_id}=#{session_id}"
        http.ssl_verify_peer = false
      end

      response_headers = parse_headers(http.header_str)
      expect(response_headers['Content-Type']).to eq "application/pdf"

      file = Tempfile.new('pdf_download')
      file.write(http.body_str)

      file.path



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

private
  def parse_headers(curl_header_string)
    http_response, *http_headers = curl_header_string.split(/[\r\n]+/).map(&:strip)
    http_headers = Hash[http_headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]
  end
end