describe PostcodeNormalizer do

  context 'private postcode normalization methods' do

    describe '#normalize' do
      it 'should normalize all postcodes in a params hash' do
        normalizer = PostcodeNormalizer.new(raw_claim_params)
        expect(normalizer.normalize).to eq(normalized_params)
      end
    end

    describe 'private method extract_submodel_names_from_collection_name' do
      it 'should return an array of keys realting to submodels in the collection' do
        params = {
          'property'         => { 'key1' => 'val1', 'key2' => 'val2' },
          'claimant_1'       => { 'key1' => 'val1', 'key2' => 'val2' },
          'claimant_22'      => { 'key1' => 'val1', 'key2' => 'val2' },
          'claimant_3'       => { 'key1' => 'val1', 'key2' => 'val2' },
          'claimant_contact' => { 'key1' => 'val1', 'key2' => 'val2' }
        }

        normalizer = PostcodeNormalizer.new( {} )
        normalizer.instance_variable_set(:@claim_params, params)
        submodels = normalizer.send(:extract_submodel_names_from_collection_name, 'claimant_collection')
        expect(submodels).to eq( %w{ claimant_1 claimant_22 claimant_3 })
      end
    end

    describe 'private method normalize_submodel_postcode' do

      let(:normalized_params) do
        normalizer = PostcodeNormalizer.new( {} )
        normalizer.instance_variable_set(:@claim_params, @params)
        normalizer.send(:normalize_submodel_postcode, 'property')
        normalizer.instance_variable_get(:@claim_params)
      end

      it 'should transform the postcode of a submodel' do
        @params = { 'property' => { 'name' => 'xxx', 'postcode' => 'sw24fh' } }
        expect(normalized_params).to eq( { 'property' => { 'name' => 'xxx', 'postcode' => 'SW2 4FH' } } )
      end

      it 'should not transform an invalid postcode' do
        @params = { 'property' => { 'name' => 'xxx', 'postcode' => 'abc255d' } }
        expect(normalized_params).to eq( { 'property' => { 'name' => 'xxx', 'postcode' => 'abc255d' } } )
      end

      it 'should not transform blank postcodes' do
        @params = { 'property' => { 'name' => 'xxx', 'postcode' => '' } }
        expect(normalized_params).to eq( { 'property' => { 'name' => 'xxx', 'postcode' => '' } } )
      end

      it 'should not choke if postcode attr doesnt exist' do
        @params = { 'property' => { 'name' => 'xxx' } }
        expect(normalized_params).to eq( { 'property' => { 'name' => 'xxx' } } )
      end

    end
  end
end

def raw_claim_params
  {
    "property"=>
    {"house"=>"Yes",
     "street"=>"kjk ;sldjfl;sdkjf; s",
     "postcode"=>"sw56ll",
     "use_live_postcode_lookup"=>false},
   "claimant_type"=>"individual",
   "num_claimants"=>"2",
   "claimant_1"=>
    {"title"=>"Mr ",
     "full_name"=>"Joe Blow",
     "organization_name"=>"",
     "street"=>"9 Made-up Lane\r\nAnytown",
     "postcode"=>"ey881zz",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>1,
     "validate_presence"=>true},
   "claimant_2"=>
    {"title"=>"Mrs",
     "full_name"=>"Jane Doe",
     "address_same_as_first_claimant"=>"Yes",
     "street"=>"",
     "postcode"=>"",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>2,
     "validate_presence"=>true},
   "claimant_3"=>
    {"title"=>"",
     "full_name"=>"",
     "street"=>"",
     "postcode"=>"",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>3,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "claimant_4"=>
    {"title"=>"",
     "full_name"=>"",
     "street"=>"",
     "postcode"=>"",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>4,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "claimant_contact"=>
    {"email"=>"johndoe@suegrabbitandrun.org.eu",
     "phone"=>"01632 960123",
     "fax"=>"",
     "dx_number"=>"",
     "title"=>"Mr ",
     "full_name"=>"John Doe",
     "company_name"=>"Sue, Grabbit and Run",
     "street"=>"16 Invented Avenue\r\nAnytown",
     "postcode"=>"ey77 8ss"},
   "reference_number"=>{"reference_number"=>""},
   "num_defendants"=>"2",
   "defendant_1"=>
    {"title"=>"Miss",
     "full_name"=>"Ann Chovey",
     "inhabits_property"=>"yes",
     "street"=>"kjk ;sldjfl;sdkjf; s",
     "postcode"=>"sw56ll",
     "defendant_num"=>1,
     "validate_presence"=>true},
   "defendant_2"=>
    {"title"=>"Miss",
     "full_name"=>"Barb Akew",
     "inhabits_property"=>"yes",
     "street"=>"kjk ;sldjfl;sdkjf; s",
     "postcode"=>"sw56ll",
     "defendant_num"=>2,
     "validate_presence"=>true},
   "defendant_3"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>3,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_4"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>4,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_5"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>5,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_6"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>6,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_7"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>7,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_8"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>8,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_9"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>9,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_10"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>10,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_11"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>11,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_12"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>12,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_13"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>13,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_14"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>14,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_15"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>15,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_16"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>16,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_17"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>17,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_18"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>18,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_19"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>19,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_20"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>20,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "notice"=>
    {"notice_served"=>"Yes",
     "served_by_name"=>"John Doe",
     "served_method"=>"In person",
     "date_served(3i)"=>"13",
     "date_served(2i)"=>"January",
     "date_served(1i)"=>"2014",
     "expiry_date(3i)"=>"13",
     "expiry_date(2i)"=>"March",
     "expiry_date(1i)"=>"2014"},
   "tenancy"=>
    {"tenancy_type"=>"assured",
     "assured_shorthold_tenancy_type"=>"one",
     "start_date(3i)"=>"1",
     "start_date(2i)"=>"January",
     "start_date(1i)"=>"2002",
     "original_assured_shorthold_tenancy_agreement_date(3i)"=>"",
     "original_assured_shorthold_tenancy_agreement_date(2i)"=>"",
     "original_assured_shorthold_tenancy_agreement_date(1i)"=>"",
     "latest_agreement_date(3i)"=>"",
     "latest_agreement_date(2i)"=>"",
     "latest_agreement_date(1i)"=>"",
     "confirmed_second_rules_period_applicable_statements"=>"Yes",
     "assured_shorthold_tenancy_notice_served_by"=>"",
     "assured_shorthold_tenancy_notice_served_date(3i)"=>"",
     "assured_shorthold_tenancy_notice_served_date(2i)"=>"",
     "assured_shorthold_tenancy_notice_served_date(1i)"=>"",
     "confirmed_first_rules_period_applicable_statements"=>"No",
     "demotion_order_date(3i)"=>"",
     "demotion_order_date(2i)"=>"",
     "demotion_order_date(1i)"=>"",
     "demotion_order_court"=>""},
   "license"=>
    {"multiple_occupation"=>"No",
     "issued_by"=>"",
     "issued_date(3i)"=>"",
     "issued_date(2i)"=>"",
     "issued_date(1i)"=>""},
   "deposit"=>
    {"received"=>"Yes",
     "as_money"=>"Yes",
     "as_property"=>"No",
     "ref_number"=>"xtNHhYqYmL",
     "information_given_date(3i)"=>"1",
     "information_given_date(2i)"=>"January",
     "information_given_date(1i)"=>"2002"},
   "court" =>
    {"court_name"=>"Good Court",
     "street"=>"1 Good Road, Goodtown",
     "postcode"=>"GT1 2XX"},
   'fee' => { 'court_fee' => '355', 'account' => '0000001234' },
   "legal_cost"=>{"legal_costs"=>""},
   "order"=>{"cost"=>"No"},
   "possession"=>{"hearing"=>"No"},
   "javascript_enabled"=>"Yes",
   "use_live_postcode_lookup"=>false
  }
end

def normalized_params
  {
    "property"=>
    {"house"=>"Yes",
     "street"=>"kjk ;sldjfl;sdkjf; s",
     "postcode"=>"SW5 6LL",
     "use_live_postcode_lookup"=>false},
   "claimant_type"=>"individual",
   "num_claimants"=>"2",
   "claimant_1"=>
    {"title"=>"Mr ",
     "full_name"=>"Joe Blow",
     "organization_name"=>"",
     "street"=>"9 Made-up Lane\r\nAnytown",
     "postcode"=>"EY88 1ZZ",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>1,
     "validate_presence"=>true},
   "claimant_2"=>
    {"title"=>"Mrs",
     "full_name"=>"Jane Doe",
     "address_same_as_first_claimant"=>"Yes",
     "street"=>"",
     "postcode"=>"",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>2,
     "validate_presence"=>true},
   "claimant_3"=>
    {"title"=>"",
     "full_name"=>"",
     "street"=>"",
     "postcode"=>"",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>3,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "claimant_4"=>
    {"title"=>"",
     "full_name"=>"",
     "street"=>"",
     "postcode"=>"",
     "claimant_type"=>"individual",
     "num_claimants"=>2,
     "claimant_num"=>4,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "claimant_contact"=>
    {"email"=>"johndoe@suegrabbitandrun.org.eu",
     "phone"=>"01632 960123",
     "fax"=>"",
     "dx_number"=>"",
     "title"=>"Mr ",
     "full_name"=>"John Doe",
     "company_name"=>"Sue, Grabbit and Run",
     "street"=>"16 Invented Avenue\r\nAnytown",
     "postcode"=>"EY77 8SS"},
   "reference_number"=>{"reference_number"=>""},
   "num_defendants"=>"2",
   "defendant_1"=>
    {"title"=>"Miss",
     "full_name"=>"Ann Chovey",
     "inhabits_property"=>"yes",
     "street"=>"kjk ;sldjfl;sdkjf; s",
     "postcode"=>"SW5 6LL",
     "defendant_num"=>1,
     "validate_presence"=>true},
   "defendant_2"=>
    {"title"=>"Miss",
     "full_name"=>"Barb Akew",
     "inhabits_property"=>"yes",
     "street"=>"kjk ;sldjfl;sdkjf; s",
     "postcode"=>"SW5 6LL",
     "defendant_num"=>2,
     "validate_presence"=>true},
   "defendant_3"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>3,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_4"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>4,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_5"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>5,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_6"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>6,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_7"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>7,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_8"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>8,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_9"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>9,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_10"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>10,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_11"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>11,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_12"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>12,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_13"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>13,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_14"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>14,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_15"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>15,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_16"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>16,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_17"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>17,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_18"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>18,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_19"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>19,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "defendant_20"=>
    {"title"=>"",
     "full_name"=>"",
     "inhabits_property"=>"",
     "street"=>"",
     "postcode"=>"",
     "defendant_num"=>20,
     "validate_absence"=>true,
     "validate_presence"=>false},
   "notice"=>
    {"notice_served"=>"Yes",
     "served_by_name"=>"John Doe",
     "served_method"=>"In person",
     "date_served(3i)"=>"13",
     "date_served(2i)"=>"January",
     "date_served(1i)"=>"2014",
     "expiry_date(3i)"=>"13",
     "expiry_date(2i)"=>"March",
     "expiry_date(1i)"=>"2014"},
   "tenancy"=>
    {"tenancy_type"=>"assured",
     "assured_shorthold_tenancy_type"=>"one",
     "start_date(3i)"=>"1",
     "start_date(2i)"=>"January",
     "start_date(1i)"=>"2002",
     "original_assured_shorthold_tenancy_agreement_date(3i)"=>"",
     "original_assured_shorthold_tenancy_agreement_date(2i)"=>"",
     "original_assured_shorthold_tenancy_agreement_date(1i)"=>"",
     "latest_agreement_date(3i)"=>"",
     "latest_agreement_date(2i)"=>"",
     "latest_agreement_date(1i)"=>"",
     "confirmed_second_rules_period_applicable_statements"=>"Yes",
     "assured_shorthold_tenancy_notice_served_by"=>"",
     "assured_shorthold_tenancy_notice_served_date(3i)"=>"",
     "assured_shorthold_tenancy_notice_served_date(2i)"=>"",
     "assured_shorthold_tenancy_notice_served_date(1i)"=>"",
     "confirmed_first_rules_period_applicable_statements"=>"No",
     "demotion_order_date(3i)"=>"",
     "demotion_order_date(2i)"=>"",
     "demotion_order_date(1i)"=>"",
     "demotion_order_court"=>""},
   "license"=>
    {"multiple_occupation"=>"No",
     "issued_by"=>"",
     "issued_date(3i)"=>"",
     "issued_date(2i)"=>"",
     "issued_date(1i)"=>""},
   "deposit"=>
    {"received"=>"Yes",
     "as_money"=>"Yes",
     "as_property"=>"No",
     "ref_number"=>"xtNHhYqYmL",
     "information_given_date(3i)"=>"1",
     "information_given_date(2i)"=>"January",
     "information_given_date(1i)"=>"2002"},
 "court" =>
    {"court_name"=>"Good Court",
     "street"=>"1 Good Road, Goodtown",
     "postcode"=>"GT1 2XX"},
   "fee" => { "court_fee" => "355", "account" => "0000001234" },
   "legal_cost"=>{"legal_costs"=>""},
   "order"=>{"cost"=>"No"},
   "possession"=>{"hearing"=>"No"},
   "javascript_enabled"=>"Yes",
   "use_live_postcode_lookup"=>false
  }
end
