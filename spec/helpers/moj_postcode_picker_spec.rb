describe 'MojPostcodePicker' do



  let(:form)    { double LabellingFormBuilder }

  describe 'new' do
    it 'calls load_haml just once the first time the class is instantiated' do
      # given an instantiated class of MojPostcodePicker with @@haml populated
      mpp = MojPostcodePicker.new(form, 'claim_property')
      expected_haml = File.open(MojPostcodePicker::TEMPLATE_FILE) { |fp| fp.read }
      expect(mpp.haml).to eq expected_haml

      # when I instantiate a second object, it should not call load_haml again,buthte haml should still be there
      expect_any_instance_of(MojPostcodePicker).not_to receive(:load_haml)
      mpp2 = MojPostcodePicker.new(form, 'claim_property')
      expect(mpp2.haml).to eq expected_haml
    end


    it 'generates default prefixes and attribute names if no options specified' do
      mpp = MojPostcodePicker.new(form, 'claim_property')
      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_property'
      expect(mpp.instance_variable_get(:@name_prefix)).to eq 'claim[property]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'postcode'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'address_lines'
    end


    it 'generates non-default prefixes and attribute names if options are specified' do
      mpp = MojPostcodePicker.new(form, 'claim_defendant_1', name_prefix: 'claim[defendant_1]', postcode_attr: 'pc', address_attr: 'street')
      expect(mpp.instance_variable_get(:@prefix)).to eq 'claim_defendant_1'
      expect(mpp.instance_variable_get(:@name_prefix)).to eq 'claim[defendant_1]'
      expect(mpp.instance_variable_get(:@postcode_attr)).to eq 'pc'
      expect(mpp.instance_variable_get(:@address_attr)).to eq 'street'
    end

  end


  describe 'emit' do
    it 'substitutes its own variables' do
      mpp = MojPostcodePicker.new(form, 'claim_property', address_attr: 'street')
      output = mpp.emit
      File.open("/Users/stephen/tmp/new.html", "w") do |fp|
        fp.puts(output)
      end
      expect(output).to eq expected_output
    end
  end

end


def expected_output
  str =<<EOF
xxx
EOF

end