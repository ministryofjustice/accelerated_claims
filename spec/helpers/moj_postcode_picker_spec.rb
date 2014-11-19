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

  end


  describe 'emit' do
    it 'substitutes its own variables' do
      allow(object).to receive(:postcode).and_return('RG2 7PU')
      allow(object).to receive(:street).and_return("50 Tregunter Road\r\nLondon")
      allow(object).to receive(:errors).and_return( {:street => [], :postcode => [] } )

      mpp = MojPostcodePicker.new(form, prefix: 'claim_property', address_attr: 'street')
      expect(mpp.emit).to eq expected_output
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




def expected_output
  str =<<EOF
<div class='postcode postcode-picker-container' data-vc='all'>
  <div class='row postcode-lookup rel js-only'>
    <div class='postcode-display hide' style='margin-bottom: 20px;'>
      Postcode:
      <span class='postcode-display-detail' style='font-weight: bold'>
        &nbsp;
      </span>
      <span>
        <a class='change-postcode-link2 js-only' href='#change_postcode' id='claim_property-manual_change-link-2' style='display: inline; margin-left: 10px;'>Change</a>
      </span>
    </div>
    <div class='postcode-selection-els'>
      <label class='postcode-picker-label' for='claim_property_postcode_edit_field'>Postcode</label>
      <input class='smalltext postcode-picker-edit-field' id='claim_property_postcode_edit_field' maxlength='8' name='[postcode]' size='8' type='text'>
      <a class='button primary postcode-picker-button' data-country='all' href='#claim_property_postcode_picker'>
        Find address
      </a>
    </div>
    <div class='postcode-picker-hourglass hide'>
      Finding address....
    </div>
    <div class='postcode-select-container sub-panel hide' style='margin-top: 0px;'>
      <fieldset class='postcode-picker-address-list'>
        <label class='hint' for='claim_property_address_select'>Please select an address</label>
        <select class='address-picker-select' id='claim_property_address_select' name='sel-address' role='listbox' size='6'>
          <option disabled='disabled' id='claim_property-listbox' role='option' value=''>Please select an address</option>
        </select>
        <a class='row button primary postcode-picker-cta' href='#claim_property_postcode_picker_manual_link' id='claim_property_selectaddress' style='margin-bottom: 20px;'>
          Select address
        </a>
      </fieldset>
    </div>
  </div>
  <div class='js-only row'>
    <a class='caption postcode-picker-manual-link' href='#claim_property_postcode_picker_manual_link' id='claim_property_postcode_picker_manual_link' style='margin-top: 20px;'>
      Enter address manually
    </a>
  </div>
  <div class='address extra no sub-panel hide' style='margin-top: 10px;'>
    <div class='row street'>
      <label for='claim_property_street'>
        Full address

      </label>
      <textarea class='street' id='claim_property_street' maxlength='70' name='claim[property][street]'>50 Tregunter Road&#x000A;London</textarea>
    </div>
    <div class='row js-only'>
      <span class='error hide' id='claim_property_street-error-message'>
        The address can’t be longer than 4 lines.
      </span>
    </div>
    <div class='row address-postcode'>
      <label for='claim_property_postcode'>
        Postcode
      </label>
      <br>
      <div style='overflow: hidden; width: 100%'>
        <input class='smalltext postcode' id='claim_property_postcode' maxlength='8' name='claim[property][postcode]' size='8' style='float: left;  margin-right: 20px;' type='text' value='RG2 7PU'>
        <a class='change-postcode-link js-only' href='#change_postcode' style='float: left;'>Change</a>
      </div>
    </div>
  </div>
</div>
EOF
  str
end
