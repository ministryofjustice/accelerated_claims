require_relative '../mocks/mock_template'

RSpec::Matchers.define :only_show_errors_inside do |expected, opts|
  opts = opts || {}
  opts = { error_css: 'span.error' }.merge(opts)
  match do |actual|
    doc                             = Nokogiri::HTML(actual)
    @count_of_all_error_messages    = doc.css(opts[:error_css]).count
    count_of_correct_error_messages = doc.css(opts[:error_css]).count{ |elem| elem.parent.name == expected.to_s }
    @total_failures                 = @count_of_all_error_messages - count_of_correct_error_messages
    (@total_failures == 0) && (@count_of_all_error_messages > 0)
  end
  failure_message do |actual|
    if @total_failures > 0
      "expected #{pluralize(@count_of_all_error_messages, 'error')} to appear inside a #{expected} tag. #{@total_failures} did not."
    elsif @count_of_all_error_messages <= 0
      "expected error messages, but did not find any."
    end
  end
end

RSpec::Matchers.define :contain_css_selectors do |expected_elements|
  match do |actual|
    doc     = Nokogiri::HTML(actual)
    @errors = []
    [expected_elements].flatten.each do |element|
      @errors << "expected `#{element}`, but did not find it" if doc.css(element).blank?
    end
    @errors.empty?
  end
  failure_message do |actual|
    'generated form had the following errors: ' + @errors.compact.join(", ")
  end
end

describe 'LabellingFormBuilder', :type => :helper  do

  let(:notice)   { double('model', class: double('class').as_null_object).as_null_object }
  let(:template) { MockTemplate.new }
  let(:form)     { LabellingFormBuilder.new('claim[notice]', notice, template, { }) }

  describe '#error_span' do
    it 'can be hidden' do
      expect(form.error_span(:notice, { hidden: true })).to have_css('span.visuallyhidden')
    end

    it 'has an id for use with aria-labelledby' do
      expect(form.error_span(:notice, { id: 'id_for_screenreader_to_target' })).to have_css('span#id_for_screenreader_to_target')
    end
  end

  describe '#moj_date_fieldset' do
    let(:date_fieldset) { form.moj_date_fieldset :date_served, 'Date notice served', { class: 'date-picker' }, 9.weeks.ago }

    it 'outputs the correct form elements' do
      expect(date_fieldset).to contain_css_selectors([
          'input.moj-date-day[type=text]',
          'input.moj-date-month[type=text]',
          'input.moj-date-year[type=text]'
      ])
    end

    it 'includes error spans' do
      messages = double('error_messages', messages: { date_served: ['date cannot be blank'] })
      expect(notice).to receive(:errors).at_least(:once).and_return(messages)

      expect(date_fieldset).to include("<span class='error' aria-hidden='true'>date cannot be blank</span>")
      expect(date_fieldset).to include("<span class='error'>date cannot be blank</span>")

      expect(date_fieldset).to only_show_errors_inside(:legend, error_css: "legend span.error")
      expect(date_fieldset).to only_show_errors_inside(:div, error_css: "div span.error")
    end
  end

  describe '#text_field_row' do
    let(:row) { form.text_field_row(:expiry_date) }

    it 'outputs the correct form element' do
      expect(row).to contain_css_selectors(['.row input[type=text]', '.row label'])
    end

    it 'shows errors inside the label' do
      messages = double('error_messages', messages: { expiry_date: ['date cannot be blank'] })
      expect(notice).to receive(:errors).at_least(:once).and_return(messages)
      expect(row).to only_show_errors_inside(:label)
    end
  end

  describe '#radio_button_field_set' do
    let(:fieldset) {
      form.radio_button_fieldset :notice_served,
      'property',
      class: 'radio'
    }

    before do
      messages = double('error_messages', messages: { notice_served: ['please select whether notice was served'] })
      allow(notice).to receive(:errors) { messages }
    end

    it 'outputs the correct form element' do
      expect(fieldset).to contain_css_selectors(
        'fieldset.radio',
        'fieldset legend',
        'input[type=radio, id=notice-house-yes]'
      )
    end

    it 'shows errors inside the legend' do
      expect(fieldset).to only_show_errors_inside(:legend, error_css: 'legend span.error')
    end

    it 'shows errors inside div' do
      expect(fieldset).to only_show_errors_inside(:div, error_css: 'div span.error')
    end
  end

  describe '#text_area_row' do
    subject { form.text_area_row(:full_address) }

    it 'outputs regular text_area_row' do
      expect(subject).to contain_css_selectors([
        '.row textarea#claim_notice_full_address', '.row label'
      ])
    end

    it 'shows errors inside the label' do
      messages = double('error_messages', messages: { full_address: ['address cannot be blank'] })
      expect(notice).to receive(:errors).at_least(:once).and_return(messages)
      expect(subject).to only_show_errors_inside(:label)
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

