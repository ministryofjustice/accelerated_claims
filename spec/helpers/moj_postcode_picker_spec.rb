# coding: utf-8
describe 'MojPostcodePicker' do

  let(:form)      { double LabellingFormBuilder }
  let(:object)    { double Object }

  before(:each) do
    allow(form).to receive(:object).and_return( object )
  end

  describe 'new' do
    it 'calls load_haml just once the first time the class is instantiated' do
      # given an instantiated class of MojPostcodePicker with @@haml populated
      allow(object).to receive(:postcode).and_return('RG2 7PU')
      allow(object).to receive(:address_lines).and_return("50 Tregunter Road\r\nLondon")

      mpp = MojPostcodePicker.new(form, prefix: 'claim_property')
      expected_haml = File.open(MojPostcodePicker::TEMPLATE_FILE) { |fp| fp.read }
      expect(mpp.haml).to eq expected_haml

      # when I instantiate a second object, it should not call load_haml again,buthte haml should still be there
      expect_any_instance_of(MojPostcodePicker).not_to receive(:load_haml)
      mpp2 = MojPostcodePicker.new(form, prefix: 'claim_property')
      expect(mpp2.haml).to eq expected_haml
    end

    it 'generates default prefixes and attribute names if no options specified' do
      allow(object).to receive(:postcode).and_return('RG2 7PU')
      allow(object).to receive(:address_lines).and_return("50 Tregunter Road\r\nLondon")

      mpp = MojPostcodePicker.new(form, prefix: 'claim_property')
      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_property'
      expect(mpp.instance_variable_get(:@name)).to eq 'claim[property]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'postcode'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'address_lines'
    end

    it 'generates non-default prefixes and attribute names if options are specified' do
      allow(object).to receive(:pc).and_return('RG2 7PU')
      allow(object).to receive(:street).and_return("50 Tregunter Road\r\nLondon")

      mpp = MojPostcodePicker.new(form, prefix: 'claim_defendant_1', name: 'claim[defendant_1]', postcode_attr: 'pc', address_attr: 'street')
      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_defendant_1'
      expect(mpp.instance_variable_get(:@name)).to eq 'claim[defendant_1]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'pc'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'street'
    end

    it 'generates non-default name' do
      allow(object).to receive(:postcode).and_return('RG2 7PU')
      allow(object).to receive(:street).and_return("50 Tregunter Road\r\nLondon")
      mpp = MojPostcodePicker.new(form, prefix: "claim_claimant_1", name: "claim[claimant_1]", address_attr: 'street')

      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_claimant_1'
      expect(mpp.instance_variable_get(:@name)).to eq 'claim[claimant_1]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'postcode'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'street'
    end

    it 'generates non-default button label' do
      allow(object).to receive(:postcode).and_return('RG2 7PU')
      allow(object).to receive(:street).and_return("50 Tregunter Road\r\nLondon")
      mpp = MojPostcodePicker.new(form, prefix: "claim_claimant_1", name: "claim[claimant_1]", address_attr: 'street', button_label: "Chercher l'adresse")

      expect(mpp.instance_variable_get(:@button_label)).to eq "Chercher l'adresse"
    end

  end

  describe 'emit' do
    it 'substitutes its own variables' do
      allow(object).to receive(:postcode).and_return('RG2 7PU')
      allow(object).to receive(:street).and_return("50 Tregunter Road\r\nLondon")
      allow(object).to receive(:errors).and_return( {:street => [], :postcode => [] } )
      allow(form).to receive(:hidden_field).and_return(hidden_field_tag_html)

      mpp = MojPostcodePicker.new(form, prefix: 'claim_property', address_attr: 'street')
      doc = Nokogiri::HTML(mpp.emit)
      expect(doc).to have_xpath('.//div[@class="postcode-display hide"][contains(.,"Postcode:")]')
      expect(doc).to have_xpath('.//a[@href="#claim_property_postcode_picker"][contains(.,"Find UK address")]')
      expect(doc).to have_xpath('.//div[@class="postcode-picker-hourglass hide"][contains(.,"Finding address....")]')
      expect(doc).to have_xpath('.//a[@href="#claim_property_postcode_picker_manual_link"][@id="claim_property_selectaddress"][contains(.,"Select address")]')
      expect(doc).to have_xpath('.//a[@href="#claim_property_postcode_picker_manual_link"][@id="claim_property_postcode_picker_manual_link"][contains(.,"Enter address manually")]')
      expect(doc).to have_xpath('.//span[@class="error"][contains(.,"The address can’t be longer than 4 lines.")]')
      expect(doc).to have_xpath('.//label[@for="claim_property_postcode"][contains(.,"Postcode")]')
    end
  end

  describe 'country_name_for_messages' do
    before(:each) do
      allow(object).to receive(:postcode).and_return('RG2 7PU')
      allow(object).to receive(:street).and_return("50 Tregunter Road\r\nLondon")
      allow(object).to receive(:errors).and_return( {:street => [], :postcode => [] } )
    end

    it 'should return England and Wales' do
      mpp = MojPostcodePicker.new(form, prefix: 'claim_property', address_attr: 'street', vc: 'england+wales')
      expect(mpp.country_name_for_messages).to eq 'England and Wales'
    end

    it 'should return UK' do
      mpp = MojPostcodePicker.new(form, prefix: 'claim_property', address_attr: 'street')
      expect(mpp.country_name_for_messages).to eq 'UK'
    end

    it 'should return England, Wales, Northern Ireland and Isle of Man' do
      mpp = MojPostcodePicker.new(form, prefix: 'claim_property', address_attr: 'street', vc: 'england+wales+northern_ireland+isle_of_man')
      expect(mpp.country_name_for_messages).to eq 'England, Wales, Northern Ireland and Isle of Man'
    end

  end

end

def hidden_field_tag_html
  %q/<input class="manual_entry_flag" id="claim_property_manually_entered_address" name="claim[property][manually_entered_address]" type="hidden" value="1">/
end
