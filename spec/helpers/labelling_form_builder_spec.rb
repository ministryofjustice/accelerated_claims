require_relative '../mocks/mock_template'

RSpec::Matchers.define :only_show_errors_inside do |expected|
  match do |actual|
    doc = Nokogiri::HTML(actual)
    count_of_all_error_messages = doc.css(".row.error span.error").count
    count_of_correct_error_messages = doc.css(".row.error span.error").count{ |elem| elem.parent.name == expected.to_s }
    @total_failures = count_of_all_error_messages - count_of_correct_error_messages
    @total_failures == 0
  end
  failure_message do |actual|
    "expected all errors to appear inside a #{expected} tag. #{@total_failures} did not."
  end
end

RSpec::Matchers.define :have_a_correctly_structured_form_for do |expected, form_element_type, model_name|
  match do |actual|
    id_attrib = "#{model_name.to_s}_#{expected.to_s}"
    doc = Nokogiri::HTML(actual)
    @errors = []
    @errors << 'missing div.row' if doc.css(".row").blank?
    label_css = ".row label[for=#{id_attrib}]"
    @errors << "expected css ``, but did not find it " if doc.css(label_css).blank?
    @errors << "expected css `.row #{form_element_type}[id=#{id_attrib}]`, but did not find it" if doc.css(".row #{form_element_type}[id=#{id_attrib}]").blank?
    @errors.compact.blank? == true
  end
  failure_message do |actual|
    'generated form had the following errors: ' + @errors.compact.join(", ")
  end
end


describe 'LabellingFormBuilder', :type => :helper  do

  let(:notice)      { double('model', class: double('class').as_null_object).as_null_object }
  let(:template)    { MockTemplate.new }
  let(:form)        { LabellingFormBuilder.new(:notice, notice, template, {}) }

  describe '#text_field_row' do
    subject { form.text_field_row(:expiry_date) }

    it 'outputs regular text_field_row' do
      expect(subject).to have_a_correctly_structured_form_for(:expiry_date, 'input[type=text]', :notice)
    end

    it 'shows errors inside the label' do
      messages = double('error_messages', messages: { expiry_date: ['date cannot be blank'] })
      expect(notice).to receive(:errors).at_least(:once).and_return(messages)
      expect(subject).to only_show_errors_inside(:label)
    end
  end

  describe '#date_select_field_set' do
    subject { form.moj_date_fieldset :date_served, 'Date notice served', { class: 'date-picker' }, 9.weeks.ago }
    #subject { form.date_select_field_set(:date, 'date', Date.today) }

    it 'outputs regular text_field_row' do
      expect(subject).to eq('bongo')
      expect(subject).to have_a_correctly_structured_form_for(:expiry_date, 'input[type=text]', :notice)
    end

    it 'shows errors inside the label' do
      messages = double('error_messages', messages: { expiry_date: ['date cannot be blank'] })
      expect(notice).to receive(:errors).at_least(:once).and_return(messages)
      expect(subject).to only_show_errors_inside(:label)
    end
  end

  describe '#text_area_row' do
    subject { form.text_area_row(:full_address) }

    it 'outputs regular text_area_row' do
      expect(subject).to have_a_correctly_structured_form_for(:full_address, 'textarea', :notice)
      expect(subject).to have_css('.row textarea#notice_full_address')
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

