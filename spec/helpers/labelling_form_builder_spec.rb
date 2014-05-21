
require_relative '../mocks/mock_template'

describe 'LabellingFormBuilder'  do

  before(:each) do
     SecureRandom.stub(:hex).with(20).and_return('0123456789abcdef')
  end

  let(:notice)      { Notice.new }
  let(:template)    { MockTemplate.new }
  let(:form)        { LabellingFormBuilder.new(:notice, notice, template, {}) }

  describe '#text_field_row' do
    it 'should output regular text_field_row' do
      form.text_field_row(:expiry_date).should == expected_text_field_html.chomp
    end
  end


  describe '#moj_date_fieldset' do

    it 'shuould intantiate an moj_date_fieldsset object with the params and call emit' do
      mdf = double MojDateFieldset
      expect(MojDateFieldset).to receive(:new).with(form, :date_served, "Date Served", {}).and_return(mdf)
      expect(mdf).to receive(:emit)

      form.moj_date_fieldset(:date_served, "Date Served")
    end
  end

end



def expected_text_field_html
  str = <<-EOHTML
<div class='row'><label for="notice_expiry_date">Expiry date</label>
<input id="notice_expiry_date" name="notice[expiry_date]" type="text" /></div>
EOHTML
end







