describe PDFDocument do

  describe 'template form' do
    def field_state_options state, file='./templates/form.pdf'
      fields = `pdftk #{file} dump_data_fields`
      fields.strip.split('---').each_with_object({}) do |fieldset, hash|
        field = fieldset[/FieldName: ([^\s]+)/,1]
        state_option = fieldset[/FieldStateOption: (#{state})/i,1]
        if field.present? && state_option.present?
          hash[field] = state_option
        end
      end
    end

    def check_field_state_options_capitalization state
      field_state_options(state).each do |field, value|
        if value != state
          fail "expected #{field} FieldStateOption: #{state}, got FieldStateOption: #{value}"
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
        pdf = @doc.fill
        pages = %x[pdftk #{pdf.path} dump_data | awk '/NumberOfPages/ {print $2}']
        expect(pages.to_i).to eq 6
      end
    end
  end
end
