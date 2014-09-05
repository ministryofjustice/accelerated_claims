require_relative '../mocks/mock_template'


feature "moj date fieldset" do


  context 'emit html' do

    before(:each) do
     allow(SecureRandom).to receive(:hex).with(20).and_return('0123456789abcdef')
    end

    let(:notice)      { Notice.new }
    let(:template)    { MockTemplate.new }
    let(:form)        { LabellingFormBuilder.new(:notice, notice, template, {}) }


    it 'should emit plain vanilla html when no options given' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', {} )
      html = mdf.emit
      expect(html).to eq(expected_vanilla_moj_date_fieldset)
    end


    it 'should emit html with fieldset and span css classes added' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', class: 'date-picker conditional' )
      html = mdf.emit
      expect(html).to eq(html_with_fieldset_classes)
    end

    it 'should emit html with id and css span classes added' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', class: 'date-picker conditional', id: 'claim_notice_date_served_error' )
      html = mdf.emit
      expect(html).to eq(html_with_fieldset_classes_and_id)
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
      expect(html).to eq(html_with_day_month_year_classes)
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
      expect(html).to eq(html_with_other_options)
    end


    it 'should emit html with a specific example date' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', {}, Date.new(2013, 1, 5))
      html = mdf.emit
      expect(html).to eq(expected_vanilla_moj_date_fieldset_with_specific_date)
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


 def expected_vanilla_moj_date_fieldset
  str = <<-EOHTML
<fieldset>
  <legend class="visuallyhidden">
    Date Notice Served
  </legend>
  <div>
    <span aria-hidden='true'>Date Notice Served</span> <span class='hint block'>For example,&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </div>
  <div class="moj-date-day-div">
    <label for="claim_notice_date_served_3i">Day</label>
    <input  class="moj-date-day"
            id="claim_notice_date_served_3i"
            maxlength="2"
            name="claim[notice][date_served(3i)]"
            size="2"
            type="text" />
  </div>
  <div class="moj-date-month-div">
    <label for="claim_notice_date_served_2i">Month</label>
    <input  class="moj-date-month"
            id="claim_notice_date_served_2i"
            maxlength="9"
            name="claim[notice][date_served(2i)]"
            size="9"
            type="text" />
  </div>
  <div class="moj-date-year-div">
    <label for="claim_notice_date_served_1i">Year</label>
    <input  class="moj-date-year"
          id="claim_notice_date_served_1i"
          maxlength="4"
          name="claim[notice][date_served(1i)]"
          size="4"
          type="text" />
  </div>
</fieldset>
EOHTML
  squash(str)
end


def expected_vanilla_moj_date_fieldset_with_specific_date
  str = <<-EOHTML
<fieldset>
  <legend class="visuallyhidden">
    Date Notice Served
  </legend>
  <div>
    <span aria-hidden='true'>Date Notice Served</span> <span class='hint block'>For example,&nbsp;&nbsp;05&nbsp;&nbsp;01&nbsp;&nbsp;2013</span>
  </div>
  <div class="moj-date-day-div">
    <label for="claim_notice_date_served_3i">Day</label>
    <input  class="moj-date-day"
            id="claim_notice_date_served_3i"
            maxlength="2"
            name="claim[notice][date_served(3i)]"
            size="2"
            type="text" />
  </div>
  <div class="moj-date-month-div">
    <label for="claim_notice_date_served_2i">Month</label>
    <input  class="moj-date-month"
            id="claim_notice_date_served_2i"
            maxlength="9"
            name="claim[notice][date_served(2i)]"
            size="9"
            type="text" />
  </div>
  <div class="moj-date-year-div">
    <label for="claim_notice_date_served_1i">Year</label>
    <input  class="moj-date-year"
          id="claim_notice_date_served_1i"
          maxlength="4"
          name="claim[notice][date_served(1i)]"
          size="4"
          type="text" />
  </div>
</fieldset>
EOHTML
  squash(str)
end



def html_with_fieldset_classes
  str = <<-EOHTML
<fieldset class="date-picker conditional">
  <legend class="visuallyhidden">
    Date Notice Served
  </legend>
  <div>
    <span aria-hidden='true'>Date Notice Served</span> <span class='hint block'>For example,&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </div>
  <div class="moj-date-day-div">
    <label for="claim_notice_date_served_3i">Day</label>
    <input  class="moj-date-day"
            id="claim_notice_date_served_3i"
            maxlength="2"
            name="claim[notice][date_served(3i)]"
            size="2"
            type="text" />
  </div>
  <div class="moj-date-month-div">
    <label for="claim_notice_date_served_2i">Month</label>
    <input  class="moj-date-month"
            id="claim_notice_date_served_2i"
            maxlength="9"
            name="claim[notice][date_served(2i)]"
            size="9"
            type="text" />
  </div>
  <div class="moj-date-year-div">
    <label for="claim_notice_date_served_1i">Year</label>
    <input  class="moj-date-year"
            id="claim_notice_date_served_1i"
            maxlength="4"
            name="claim[notice][date_served(1i)]"
            size="4"
            type="text" />
  </div>
</fieldset>
EOHTML
  squash(str)
end


def html_with_fieldset_classes_and_id
  str = <<-EOHTML
<fieldset class="date-picker conditional" id="claim_notice_date_served_error">
  <legend class="visuallyhidden">
    Date Notice Served
  </legend>
  <div>
    <span aria-hidden='true'>Date Notice Served</span> <span class='hint block'>For example,&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </div>
  <div class="moj-date-day-div">
    <label for="claim_notice_date_served_3i">Day</label>
    <input  class="moj-date-day"
            id="claim_notice_date_served_3i"
            maxlength="2"
            name="claim[notice][date_served(3i)]"
            size="2"
            type="text" />
  </div>
  <div class="moj-date-month-div">
    <label for="claim_notice_date_served_2i">Month</label>
    <input  class="moj-date-month"
            id="claim_notice_date_served_2i"
            maxlength="9"
            name="claim[notice][date_served(2i)]"
            size="9"
            type="text" />
  </div>
  <div class="moj-date-year-div">
    <label for="claim_notice_date_served_1i">Year</label>
    <input  class="moj-date-year"
            id="claim_notice_date_served_1i"
            maxlength="4"
            name="claim[notice][date_served(1i)]"
            size="4"
            type="text" />
  </div>
</fieldset>
EOHTML
  squash(str)
end


def html_with_day_month_year_classes
  str = <<-EOHTML
<fieldset class="date-picker conditional" id="xxxxx">
  <legend class="visuallyhidden">
    Date Notice Served
  </legend>
  <div>
    <span aria-hidden='true'>Date Notice Served</span> <span class='hint block'>For example,&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </div>
  <div class="moj-date-day-div">
    <label for="claim_notice_date_served_3i">Day</label>
  <input  class="my-special-day mydate"
          id="claim_notice_date_served_3i"
          maxlength="2"
          name="claim[notice][date_served(3i)]"
          size="2"
          type="text" />
  </div>
  <div class="moj-date-month-div">
    <label for="claim_notice_date_served_2i">Month</label>
    <input  class="my-special-month mydate"
            id="claim_notice_date_served_2i"
            maxlength="9"
            name="claim[notice][date_served(2i)]"
            size="9"
            type="text" />
  </div>
  <div class="moj-date-year-div">
    <label for="claim_notice_date_served_1i">Year</label>
    <input  class="my-special-year mydate"
          id="claim_notice_date_served_1i"
          maxlength="4"
          name="claim[notice][date_served(1i)]"
          size="4"
          type="text" />
  </div>
</fieldset>
EOHTML
  squash(str)
end


def html_with_other_options
    str = <<-EOHTML
<fieldset class="date-picker conditional">
  <legend class="visuallyhidden">
    Date Notice Served
  </legend>
  <div>
    <span aria-hidden='true'>Date Notice Served</span> <span class='hint block'>For example,&nbsp;&nbsp;#{Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')}</span>
  </div>
  <div class="moj-date-day-div">
    <label for="claim_notice_date_served_3i">Day</label>
    <input  class="my-special-day mydate"
            id="claim_notice_date_served_3i"
            maxlength="2"
            name="claim[notice][date_served(3i)]"
            placeholder="dd"
            size="2"
            type="text" />
  </div>
  <div class="moj-date-month-div">
    <label for="claim_notice_date_served_2i">Month</label>
    <input  class="my-special-month mydate"
            id="claim_notice_date_served_2i"
            maxlength="9"
            name="claim[notice][date_served(2i)]"
            placeholder="month"
            size="9"
            type="text" />
  </div>
  <div class="moj-date-year-div">
    <label for="claim_notice_date_served_1i">Year</label>
    <input  class="my-special-year mydate"
            id="claim_notice_date_served_1i"
            maxlength="4"
            name="claim[notice][date_served(1i)]"
            size="4"
            type="text" />
  </div>
</fieldset>
EOHTML
  squash(str)
end


def squash(str)
  str.gsub!("\n", "")
  str.gsub!(/\s+/," ")
  str.gsub!(" <", "<")
  str.gsub!("> ", ">")
  str.gsub!('span><span','span> <span')
  str
end

end
