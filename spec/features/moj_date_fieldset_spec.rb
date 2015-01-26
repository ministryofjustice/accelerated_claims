require_relative '../mocks/mock_template'

feature "moj date fieldset" do

  def expect_equal actual, expected
    expect(actual.gsub("><",">\n<")).to eq(expected.gsub("><",">\n<"))
  end

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
      expect_equal html, expected_date_fieldset
    end

    it 'should emit html with fieldset and span css classes added' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', class: 'date-picker conditional' )
      html = mdf.emit
      expect_equal html, expected_date_fieldset(fieldset_class: ' class="date-picker conditional"')
    end

    it 'should emit html with id and css span classes added' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', class: 'date-picker conditional', id: 'claim_notice_date_served_error' )
      html = mdf.emit
      expect_equal html, expected_date_fieldset(fieldset_class: ' class="date-picker conditional"', fieldset_id: ' id="claim_notice_date_served_error"')
    end

    it 'should emit html with day month year css classes added' do
      options = {
        '_day'    => {class: 'my-special-day mydate'},
        '_month'  => {class: 'my-special-month mydate'},
        '_year'   => {class: 'my-special-year mydate'}
      }
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', options )
      html = mdf.emit
      expect_equal html, expected_date_fieldset(input_class: ' mydate', input_class_prefix: 'my-special')
    end

    it 'should emit html with other options added' do
      options = {
        '_day'    => { placeholder: 'dd'},
        '_month'  => { placeholder: 'dd'},
        '_year'   => { placeholder: 'dd'}
      }
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', options )
      html = mdf.emit
      expect_equal html, expected_date_fieldset(input_options: ' placeholder="dd"')
    end

    it 'should emit html with a specific example date' do
      mdf = MojDateFieldset.new(form, :date_served, 'Date Notice Served', {}, Date.new(2013, 1, 5))
      html = mdf.emit
      expect_equal html, expected_date_fieldset(date_example: '05&nbsp;&nbsp;01&nbsp;&nbsp;2013')
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

 def expected_date_fieldset options={}
  date_example = options[:date_example] || Date.today.strftime('%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y')
  fieldset_class = options[:fieldset_class] || ''
  fieldset_id = options[:fieldset_id] || ''
  input_class = options[:input_class] || ''
  input_class_prefix = options[:input_class_prefix] || 'moj-date'
  input_options = options[:input_options] || ''

  str = <<-EOHTML
<fieldset#{fieldset_class}#{fieldset_id}>
  <legend>
    Date Notice Served
    <span class='hint block'>For example,&nbsp;&nbsp;#{date_example}</span>
  </legend>
  <div class="form-date">
    <div class="form-group form-group-day">
      <label for="claim_notice_date_served_3i">Day</label>
      <input  maxlength="2"
              id="claim_notice_date_served_3i"
              name="claim[notice][date_served(3i)]"
              class="#{input_class_prefix}-day#{input_class}"
              #{input_options}
              size="2"
              type="text" />
    </div>
    <div class="form-group form-group-month">
      <label for="claim_notice_date_served_2i">Month</label>
      <input  maxlength="9"
              id="claim_notice_date_served_2i"
              name="claim[notice][date_served(2i)]"
              class="#{input_class_prefix}-month#{input_class}"
              #{input_options}
              size="9"
              type="text" />
    </div>
    <div class="form-group form-group-year">
      <label for="claim_notice_date_served_1i">Year</label>
      <input maxlength="4"
             id="claim_notice_date_served_1i"
             name="claim[notice][date_served(1i)]"
             class="#{input_class_prefix}-year#{input_class}"
             #{input_options}
             size="4"
             type="text" />
    </div>
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
    str.gsub!('Served<span', 'Served <span')
    str
  end

end
