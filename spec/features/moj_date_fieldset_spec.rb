require_relative '../mocks/mock_template'


feature "moj date fieldset" do

  before do
    stub_request(:post, "http://localhost:4000/").
      to_return(:status => 200, :body => "", :headers => {})

     WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  context 'submitting form without javascript' do
    unless remote_test?
      scenario "user types two digit numeric day two digit numeric month: 13 01 2014" do
        data, expected_data = update_data_and_results('2014-01-13')
        run_scenario(data, expected_data, js: false)
      end
    end
  end


  context 'submitting form with javascript' do
    scenario "user types two digit numeric day two digit numeric month: 13 01 2014", js: true do
      data, expected_data = update_data_and_results('2014-01-13')
      run_scenario(data, expected_data, js: true)
    end
  end




  context 'emit html' do

    before(:each) do
     SecureRandom.stub(:hex).with(20).and_return('0123456789abcdef')
    end

    let(:notice)      { Notice.new }
    let(:template)    { MockTemplate.new }
    let(:form)        { LabellingFormBuilder.new(:notice, notice, template, {}) }

        
    it 'should emit plain vanilla html when no options given' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', {} )
      html = mdf.emit
      html.should == expected_vanilla_moj_date_fieldset
    end


    it 'should emit html with fieldset and span css classes added' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', class: 'date-picker conditional' )
      html = mdf.emit
      html.should == html_with_fieldset_classes
    end

    it 'should emit html with id and css span classes added' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', class: 'date-picker conditional', id: 'claim_notice_date_served_error' )
      html = mdf.emit
      html.should == html_with_fieldset_classes_and_id
    end


    it 'should emit html with day month year css classes added' do
      options = {
        :class    => 'date-picker conditional',
        :id       => 'xxxxx',
        '_day'    => {class: 'my-special-day mydate'},
        '_month'  => {class: 'my-special-month mydate'},
        '_year'   => {class: 'my-special-year mydate'} 
      }
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', options )
      html = mdf.emit
      html.should == html_with_day_month_year_classes
    end


    it 'should emit html with other options added' do
      options = {
        :class    => 'date-picker conditional',
        '_day'    => {class: 'my-special-day mydate', placeholder: 'dd'},
        '_month'  => {class: 'my-special-month mydate', placeholder: 'month'},
        '_year'   => {class: 'my-special-year mydate'} 
      }
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', options )
      html = mdf.emit
      html.should == html_with_other_options
    end


  end



  def update_data_and_results(date_string, result_fields = {})
    data = load_fixture_data(1)
    data['claim']['notice']['date_served'] = date_string
    expected_data = load_expected_data(1)
    result_fields.each do |field, new_value|
      expected_data[field.to_s] = new_value
    end
    [data, expected_data]
  end



  def run_scenario(data, expected_data, options)

    AppModel.new(data).exec do
      homepage.visit
      # homepage.start_claim
      if options[:js]
        claim_form.complete_form_with_javascript
      else
        claim_form.complete_form
      end
      claim_form.submit

      confirmation_page.is_displayed?.should be_true, claim_form.validation_error_text

      pdf_filename = confirmation_page.download_pdf
      pdf.load pdf_filename
      if(ENV.key? 'save_pdf')
        File.rename(pdf_filename, "spec/fixtures/pdfs/scenario_#{index}.pdf")
        pdf.write_hash_to_file("spec/fixtures/scenario_#{index}_results.rb")
      else
        pdf.assert_pdf_is_correct(expected_data)
      end
    end
  end

 
 def expected_vanilla_moj_date_fieldset
  str = <<-EOHTML
<fieldset aria-describedby="_0123456789abcdef" class="">
  <span class="legend" id="_0123456789abcdef">
    Date Notice Served<span class="hint block">eg&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </span>
  <input  class="moj-date-day" 
          id="claim_notice_date_served_3i" 
          maxlength="2" 
          name="claim[notice][date_served(3i)]" 
          size="2" 
          type="text" />
  &nbsp;
  <input  class="moj-date-month" 
          id="claim_notice_date_served_2i" 
          maxlength="9" 
          name="claim[notice][date_served(2i)]" 
          size="9" 
          type="text" />
  &nbsp
  <input  class="moj-date-year" 
          id="claim_notice_date_served_1i" 
          maxlength="4" 
          name="claim[notice][date_served(1i)]" 
          size="4" 
          type="text" />
</fieldset>
EOHTML
  squash(str)
end


def html_with_fieldset_classes
  str = <<-EOHTML
<fieldset aria-describedby="_0123456789abcdef" class="date-picker conditional">
  <span class="legend" id="_0123456789abcdef">
    Date Notice Served<span class="hint block">eg&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </span>
  <input  class="moj-date-day" 
          id="claim_notice_date_served_3i" 
          maxlength="2" 
          name="claim[notice][date_served(3i)]" 
          size="2" 
          type="text" />
  &nbsp;
  <input  class="moj-date-month" 
          id="claim_notice_date_served_2i" 
          maxlength="9" 
          name="claim[notice][date_served(2i)]" 
          size="9" 
          type="text" />
  &nbsp
  <input  class="moj-date-year" 
          id="claim_notice_date_served_1i" 
          maxlength="4" 
          name="claim[notice][date_served(1i)]" 
          size="4" 
          type="text" />
</fieldset>
EOHTML
  squash(str)
end


def html_with_fieldset_classes_and_id
  str = <<-EOHTML
<fieldset aria-describedby="claim_notice_date_served_error" class="date-picker conditional">
  <span class="legend" id="claim_notice_date_served_error">
    Date Notice Served<span class="hint block">eg&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </span>
  <input  class="moj-date-day" 
          id="claim_notice_date_served_3i" 
          maxlength="2" 
          name="claim[notice][date_served(3i)]" 
          size="2" 
          type="text" />
  &nbsp;
  <input  class="moj-date-month" 
          id="claim_notice_date_served_2i" 
          maxlength="9" 
          name="claim[notice][date_served(2i)]" 
          size="9" 
          type="text" />
  &nbsp
  <input  class="moj-date-year" 
          id="claim_notice_date_served_1i" 
          maxlength="4" 
          name="claim[notice][date_served(1i)]" 
          size="4" 
          type="text" />
</fieldset>
EOHTML
  squash(str)
end


def html_with_day_month_year_classes
  str = <<-EOHTML
<fieldset aria-describedby="xxxxx" class="date-picker conditional">
  <span class="legend" id="xxxxx">
    Date Notice Served<span class="hint block">eg&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </span>
  <input  class="my-special-day mydate" 
          id="claim_notice_date_served_3i" 
          maxlength="2" 
          name="claim[notice][date_served(3i)]" 
          size="2" 
          type="text" />
  &nbsp;
  <input  class="my-special-month mydate" 
          id="claim_notice_date_served_2i" 
          maxlength="9" 
          name="claim[notice][date_served(2i)]" 
          size="9" 
          type="text" />
  &nbsp
  <input  class="my-special-year mydate" 
          id="claim_notice_date_served_1i" 
          maxlength="4" 
          name="claim[notice][date_served(1i)]" 
          size="4" 
          type="text" />
</fieldset>
EOHTML
  squash(str)
end


def html_with_other_options
    str = <<-EOHTML
<fieldset aria-describedby="_0123456789abcdef" class="date-picker conditional">
  <span class="legend" id="_0123456789abcdef">
    Date Notice Served<span class="hint block">eg&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </span>
  <input  class="my-special-day mydate" 
          id="claim_notice_date_served_3i" 
          maxlength="2" 
          name="claim[notice][date_served(3i)]" 
          placeholder="dd" 
          size="2" 
          type="text" />
  &nbsp;
  <input  class="my-special-month mydate" 
          id="claim_notice_date_served_2i" 
          maxlength="9" 
          name="claim[notice][date_served(2i)]" 
          placeholder="month" 
          size="9" 
          type="text" />
  &nbsp
  <input  class="my-special-year mydate" 
          id="claim_notice_date_served_1i" 
          maxlength="4" 
          name="claim[notice][date_served(1i)]" 
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



end
