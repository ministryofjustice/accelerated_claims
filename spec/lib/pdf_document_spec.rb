describe PDFDocument do

  describe 'template form' do
    before(:all) do
      @fields = `pdftk ./templates/form.pdf dump_data_fields`
    end

    def field_state_options state
      @fields.strip.split('---').each_with_object({}) do |fieldset, hash|
        field = fieldset[/FieldName: ([^\s]+)/,1]
        state_option = fieldset[/FieldStateOption: (#{state})/i,1]
        if field.present? && state_option.present?
          hash[field] = state_option
        end
      end
    end

    def check_field_state_options_capitalization expected_state_value
      field_state_options(expected_state_value).each do |field, state_value|
        if state_value != expected_state_value
          fail "expected #{field} FieldStateOption: #{expected_state_value}, got FieldStateOption: #{state_value}"
        end
      end
    end

    it 'all "No" field state options correctly capitalised' do
      check_field_state_options_capitalization 'No'
    end

    it 'all "Yes" field state options correctly capitalised' do
      check_field_state_options_capitalization 'Yes'
    end

    it 'all "NA" field state options correctly capitalised' do
      check_field_state_options_capitalization 'NA'
    end
  end

  context 'connnection refused to strike through service' do
    before do
      @doc = PDFDocument.new(json)
      stub_request(:post, "http://localhost:4000/").
          to_raise(Faraday::ConnectionFailed)
    end

    describe ".fill" do
      let(:json) { claim_formatted_data }

      it "should return a file path" do
        expect(@doc).to receive(:use_strike_through_command)
        pdf = @doc.fill
        expect(pdf.path).to match '/tmp/accelerated_claim'
      end
    end
  end

  context 'successful strike through' do
    before do
      @doc = PDFDocument.new(json)
      stub_request(:post, "http://localhost:4000/").
           to_return(:status => 200, :body => "", :headers => {})
    end

    describe ".fill" do
      let(:json) { claim_formatted_data }

      it "should respond to .fill" do
        expect(@doc).to respond_to(:fill)
      end

      it "should return a file path" do
        pdf = @doc.fill
        expect(pdf.path).to match '/tmp/accelerated_claim'
      end
    end

    describe "when given data with one defendant" do
      let(:json) do
        data = claim_formatted_data
        data.delete "defendant_two_address"
        data
      end

      it "should produce 5 page PDF" do
        pdf = @doc.fill
        pages = %x[pdftk #{pdf.path} dump_data | awk '/NumberOfPages/ {print $2}']
        expect(pages.to_i).to eq 5
      end
    end

    describe "when given data with two defendants" do
      let(:json) { claim_formatted_data }

      it "should produce 6 page PDF" do
        pp json
        pdf = @doc.fill
        pages = %x[pdftk #{pdf.path} dump_data | awk '/NumberOfPages/ {print $2}']
        expect(pages.to_i).to eq 6
      end
    end
  end
end
