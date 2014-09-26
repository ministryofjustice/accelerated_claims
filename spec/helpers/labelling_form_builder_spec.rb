require_relative '../mocks/mock_template'

describe 'LabellingFormBuilder', :type => :helper  do

  before(:each) do
     allow(SecureRandom).to receive(:hex).with(20).and_return('0123456789abcdef')
  end

  let(:notice)      { Notice.new }
  let(:template)    { MockTemplate.new }
  let(:form)        { LabellingFormBuilder.new(:notice, notice, template, {}) }

  describe '#text_field_row' do
    it 'should output regular text_field_row' do
      expect(form.text_field_row(:expiry_date)).to eq(expected_text_field_html.chomp)
    end
  end


  describe '#moj_date_fieldset' do

    it 'instantiates an moj_date_fieldsset object with the params and call emit' do
      mdf = double MojDateFieldset
      expect(MojDateFieldset).to receive(:new).with(form, :date_served, "Date Served", {}, Date.today, nil).and_return(mdf)
      expect(mdf).to receive(:emit)

      form.moj_date_fieldset(:date_served, "Date Served")
    end


    it 'instantiates an moj_date_fieldset opject with a specific date' do
      mdf = double MojDateFieldset
      expect(MojDateFieldset).to receive(:new).with(form, :date_served, "Date Served", {}, Date.new(2014, 12, 25), nil).and_return(mdf)
      expect(mdf).to receive(:emit)

      form.moj_date_fieldset(:date_served, "Date Served", {}, Date.new(2014, 12, 25))
    end
  end

end

def expected_text_field_html
  str = <<-EOHTML
<div class='row'><label for="notice_expiry_date">Expiry date</label>
<input id="notice_expiry_date" name="notice[expiry_date]" type="text" /></div>
EOHTML
end

