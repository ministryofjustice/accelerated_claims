describe PDFDocument do
  before(:each) { @doc = PDFDocument.new(json) }

  describe ".fill" do
    let(:json) { claim_formatted_data }

    it "should respond to .fill" do
      @doc.should respond_to(:fill)
    end

    it "should return a file path" do
      @doc.fill.should match '/tmp/accelerated_claim'
    end
  end

  describe "when given data with one defendant" do
    let(:json) do
      data = claim_formatted_data
      data.delete "defendant_two_address"
      data
    end

    it "should produce 4 page PDF" do
      pages = %x[pdftk #{@doc.fill} dump_data | awk '/NumberOfPages/ {print $2}']
      pages.to_i.should eq 4
    end
  end

  describe "when given data with two defendants" do
    let(:json) { claim_formatted_data }

    it "should produce 5 page PDF" do
      pdf = @doc.fill
      pages = %x[pdftk #{pdf} dump_data | awk '/NumberOfPages/ {print $2}']
      pages.to_i.should eq 5
    end
  end
end
