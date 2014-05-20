
class MockTemplate
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper

  attr_accessor :output_buffer

  def surround(start_html, end_html, &block)
    "#{start_html}#{block.call}#{end_html}"
  end



end


describe 'LabellingFormBuilder'  do

  before(:each) do
     SecureRandom.stub(:hex).with(20).and_return('0123456789abcdef')
  end

  let(:notice)      { Notice.new }
  let(:template)    { MockTemplate.new }
  let(:form)        { LabellingFormBuilder.new(:notice, notice, template, {}) }

  describe '#text_field_row' do
    it 'shoud' do
      form.text_field_row(:expiry_date).should == expected_text_field_html.chomp
    end
  end


  describe '#moj_date_fieldset' do

    it 'should produce vanilla html without additional options' do
      html = form.moj_date_fieldset(:date_served, 'Date Notice Served')
      html.should == expected_vanilla_moj_date_fieldset
    end


    it 'should produce html with additional classes' do
      html = form.moj_date_fieldset(:date_served, 'Date Notice Served', class: "rel conditional original")
      html.should == expected_moj_date_fieldset_with_additional_classes
    end
  end

end



def expected_text_field_html
  str = <<-EOHTML
<div class='row'><label for="notice_expiry_date">Expiry date</label>
<input id="notice_expiry_date" name="notice[expiry_date]" type="text" /></div>
EOHTML
end

def expected_vanilla_moj_date_fieldset
  str = <<-EOHTML
<fieldset aria-describedby="_0123456789abcdef" class="">
  <span class="legend" id="_0123456789abcdef">
    Date Notice Served
  </span>
  <input  class="moj-date-day" 
          id="claim_notice_date_served_3i" 
          maxlength="2" 
          name="claim[notice][date_served(3i)]" 
          placeholder="DD" 
          size="2" 
          type="text" />
  &nbsp;
  <input  class="moj-date-month" 
          id="claim_notice_date_served_2i" 
          maxlength="9" 
          name="claim[notice][date_served(2i)]" 
          placeholder="MM" 
          size="9" 
          type="text" />
  &nbsp
  <input  class="moj-date-year" 
          id="claim_notice_date_served_1i" 
          maxlength="4" 
          name="claim[notice][date_served(1i)]" 
          placeholder="YYYY" 
          size="4" 
          type="text" />
</fieldset>
EOHTML
  squash(str)
end

def expected_moj_date_fieldset_with_additional_classes
  str = <<-EOHTML
<fieldset aria-describedby="_0123456789abcdef" class="rel conditional original">
  <span class="legend" id="_0123456789abcdef">
    Date Notice Served
  </span>
  <input  class="moj-date-day rel conditional original" 
          id="claim_notice_date_served_3i" 
          maxlength="2" 
          name="claim[notice][date_served(3i)]" 
          placeholder="DD" 
          size="2" 
          type="text" />
  &nbsp;
  <input  class="moj-date-month rel conditional original" 
          id="claim_notice_date_served_2i" 
          maxlength="9" 
          name="claim[notice][date_served(2i)]" 
          placeholder="MM" 
          size="9" 
          type="text" />
  &nbsp
  <input  class="moj-date-year rel conditional original" 
          id="claim_notice_date_served_1i" 
          maxlength="4" 
          name="claim[notice][date_served(1i)]" 
          placeholder="YYYY" 
          size="4" 
          type="text" />
</fieldset>
EOHTML
  squash(str)
end



def squash(str)
  str.gsub!("\n", "")
  str.gsub!(/\s+/," ")
  str.gsub!(" <", "<")
  str.gsub!("> ", ">")
  str
end






