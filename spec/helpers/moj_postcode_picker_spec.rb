describe 'MojPostcodePicker' do



  let(:form)      { double LabellingFormBuilder }
  
  describe 'new' do
    it 'calls load_haml just once the first time the class is instantiated' do
      # given an instantiated class of MojPostcodePicker with @@haml populated
      mpp = MojPostcodePicker.new(form, prefix: 'claim_property')
      expected_haml = File.open(MojPostcodePicker::TEMPLATE_FILE) { |fp| fp.read }
      expect(mpp.haml).to eq expected_haml

      # when I instantiate a second object, it should not call load_haml again,buthte haml should still be there
      expect_any_instance_of(MojPostcodePicker).not_to receive(:load_haml)
      mpp2 = MojPostcodePicker.new(form, prefix: 'claim_property')
      expect(mpp2.haml).to eq expected_haml
    end


    it 'generates default prefixes and attribute names if no options specified' do
      mpp = MojPostcodePicker.new(form, prefix: 'claim_property')
      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_property'
      expect(mpp.instance_variable_get(:@name)).to eq 'claim[property]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'postcode'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'address_lines'
    end


    it 'generates non-default prefixes and attribute names if options are specified' do
      mpp = MojPostcodePicker.new(form, prefix: 'claim_defendant_1', name: 'claim[defendant_1]', postcode_attr: 'pc', address_attr: 'street')
      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_defendant_1'
      expect(mpp.instance_variable_get(:@name)).to eq 'claim[defendant_1]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'pc'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'street'
    end

    it 'generates non-default name' do
      mpp = MojPostcodePicker.new(form, prefix: "claim_claimant_1", name: "claim[claimant_1]", address_attr: 'street')
      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_claimant_1'
      expect(mpp.instance_variable_get(:@name)).to eq 'claim[claimant_1]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'postcode'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'street'
    end

  end


  describe 'emit' do
    it 'substitutes its own variables' do
      mpp = MojPostcodePicker.new(form, prefix: 'claim_property', address_attr: 'street')
      expect(mpp.emit).to eq expected_output
    end
  end

end




def expected_output
  str =<<EOF
<div class='row postcode postcode-picker-container'>
  <div class='postcode-lookup rel js-only'>
    <div class='postcode-display hide'>
      Postcode:
      <span class='postcode_display_detail'>
        XJJ1 7GG
      </span>
    </div>
    <div class='postcode-selection-els'>
      <label class='postcode-picker-label' for='claim_property_postcode_edit_field'>Postcode</label>
      <input class='smalltext postcode-picker-edit-field' id='claim_property_postcode_edit_field' maxlength='8' name='[postcode]' size='8' type='text'>
      <a class='button primary postcode-picker-button' href='#claim_property_postcode_picker' name='FindUkPostcode'>
        Find UK Address
      </a>
    </div>
    <div class='postcode-picker-hourglass hide'>
      Finding address....
    </div>
    <div class='postcode-select-container sub-panel hide'>
      <fieldset class='postcode-picker-address-list'>
        <label class='hint' for='claim_property_address_select'>Please select an address</label>
        <select class='address-picker-select' id='claim_property_address_select' name='sel-address' size='6' width='50'>
          <option disabled='disabled' id='listbox-0' role='option' value=''>Please select an address</option>
        </select>
        <a class='button primary postcode-picker-cta' href='#claim_property_postcode_picker_manual_link' id='claim_property_selectaddress' name='SelectAddress'>
          Select Address
        </a>
      </fieldset>
    </div>
    <div class='js-only'>
      <a class='caption postcode-picker-manual-link' href='#claim_property_postcode_picker_manual_link' id='claim_property_postcode_picker_manual_link'>
        I want to add an address myself
      </a>
    </div>
  </div>
  <div class='address extra no sub-panel hide'>
    <div class='street'>
      <label for='claim_property_street'>Full address</label>
      <textarea class='street' id='claim_property_street' maxlength='70' name='claim[property][street]'></textarea>
    </div>
    <div class='row js-only'>
      <span class='error hide' id='claim_property_street-error-message'>
        The address can’t be longer than 4 lines.
      </span>
    </div>
    <div class='postcode'>
      <label for='claim_property_postcode'>Postcode</label>
      <div style='overflow: hidden; width: 100%'>
        <input class='smalltext postcode' id='claim_property_postcode' maxlength='8' name='claim[property][postcode]' size='8' style='float: left;  margin-right: 20px;' type='text'>
        <a class='change-postcode-link js-only' href='#claim_property_postcode_picker_manual_link' style='float: left;'>Change</a>
      </div>
    </div>
  </div>
</div>
EOF
  str
end


