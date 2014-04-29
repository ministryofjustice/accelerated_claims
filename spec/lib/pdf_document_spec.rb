describe PDFDocument do

  context 'connnection refused to strike through service' do
    before do
      @doc = PDFDocument.new(json)
      stub_request(:post, "http://localhost:4000/").
          to_raise(Faraday::ConnectionFailed)
    end

    describe ".fill" do
      let(:json) { claim_formatted_data }

      it "should return a file path" do
        @doc.should_receive(:use_strike_through_command)
        pdf = @doc.fill
        pdf.path.should match '/tmp/accelerated_claim'
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
        @doc.should respond_to(:fill)
      end

      it "should return a file path" do
        pdf = @doc.fill
        pdf.path.should match '/tmp/accelerated_claim'
      end
    end

    describe "when given data with one defendant" do
      let(:json) do
        data = claim_formatted_data
        data.delete "defendant_two_address"
        data
      end

      it "should produce 4 page PDF" do
        pdf = @doc.fill
        pages = %x[pdftk #{pdf.path} dump_data | awk '/NumberOfPages/ {print $2}']
        pages.to_i.should eq 4
      end
    end

    describe "when given data with two defendants" do
      let(:json) { claim_formatted_data }

      it "should produce 5 page PDF" do
        pdf = @doc.fill
        pages = %x[pdftk #{pdf.path} dump_data | awk '/NumberOfPages/ {print $2}']
        pages.to_i.should eq 5
      end
    end
  end
end
