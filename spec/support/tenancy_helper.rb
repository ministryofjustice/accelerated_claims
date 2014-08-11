module TenancyHelper

  def value attribute, default, overrides
    overrides.has_key?(attribute) ? overrides.delete(attribute) : default
  end

  def assured_tenancy overrides={}
    date_fields = {}.merge (
      form_date(:start_date, value(:start_date, Date.parse("2010-01-05"), overrides))
    ).merge (
      form_date(:assured_shorthold_tenancy_notice_served_date, value(:assured_shorthold_tenancy_notice_served_date, nil, overrides))
    ).merge (
      form_date(:original_assured_shorthold_tenancy_agreement_date, value(:original_assured_shorthold_tenancy_agreement_date, nil, overrides))
    ).merge (
      form_date(:latest_agreement_date, value(:latest_agreement_date, nil, overrides))
    )

    Tenancy.new({
      tenancy_type: 'assured',
      assured_shorthold_tenancy_type: 'one',
      agreement_reissued_for_same_property: nil,
      agreement_reissued_for_same_landlord_and_tenant: nil,
      confirmed_second_rules_period_applicable_statements: 'Yes',
      confirmed_first_rules_period_applicable_statements: 'No'
    }.merge(date_fields).merge(overrides)
    )
  end

  def demoted_tenancy overrides={}
    date_fields = {}.merge(
      form_date(:demotion_order_date, value(:demotion_order_date, Date.parse("2010-01-01"), overrides))
    )

    Tenancy.new({
      tenancy_type: 'demoted',
      demotion_order_court: "Brighton County Court",
      previous_tenancy_type: "assured",
      confirmed_second_rules_period_applicable_statements: 'No',
      confirmed_first_rules_period_applicable_statements: 'No'
    }.merge(date_fields).merge(overrides))
  end

  shared_examples_for 'confirm 1st rules period applicable statements' do
    context 'and 1st rules period applicable statements are confirmed' do
      before do
        @tenancy.confirmed_first_rules_period_applicable_statements = 'Yes'
        @tenancy.confirmed_second_rules_period_applicable_statements = 'No'
      end

      it 'is valid' do
        expect(@tenancy).to be_valid
      end
    end

    context 'and 1st rules period applicable statements are not confirmed' do
      before do
        @tenancy.confirmed_first_rules_period_applicable_statements = 'No'
        @tenancy.confirmed_second_rules_period_applicable_statements = 'No'
      end

      it 'is invalid' do
        expect(@tenancy).not_to be_valid
      end

      it 'has appropriate error message' do
        @tenancy.valid?
        expect(@tenancy.errors[:confirmed_first_rules_period_applicable_statements]).to eq ['Please read the statements and tick if they apply']
        expect(@tenancy.errors[:confirmed_second_rules_period_applicable_statements]).to eq []
      end
    end

    context 'and both rules periods applicable statements are confirmed' do
      before do
        @tenancy.confirmed_first_rules_period_applicable_statements = 'Yes'
        @tenancy.confirmed_second_rules_period_applicable_statements = 'Yes'
      end

      it 'is invalid' do
        expect(@tenancy).not_to be_valid
      end

      it 'has appropriate error message' do
        @tenancy.valid?
        expect(@tenancy.errors[:confirmed_first_rules_period_applicable_statements]).to eq []
        expect(@tenancy.errors[:confirmed_second_rules_period_applicable_statements]).to eq ['leave blank as you specified original tenancy agreement was made before 28 February 1997']
      end
    end
  end

  shared_examples_for 'confirm 2nd rules period applicable statements' do
    context 'and 2nd rules period applicable statements are confirmed' do
      before do
        @tenancy.confirmed_first_rules_period_applicable_statements = 'No'
        @tenancy.confirmed_second_rules_period_applicable_statements = 'Yes'
      end

      it 'is valid' do
        expect(@tenancy).to be_valid
      end
    end

    context 'and 2nd rules period applicable statements are not confirmed' do
      before do
        @tenancy.confirmed_first_rules_period_applicable_statements = 'No'
        @tenancy.confirmed_second_rules_period_applicable_statements = 'No'
      end

      it 'is invalid' do
        expect(@tenancy).to_not be_valid
      end

      it 'has appropriate error message' do
        @tenancy.valid?
        expect(@tenancy.errors[:confirmed_first_rules_period_applicable_statements]).to eq []
        expect(@tenancy.errors[:confirmed_second_rules_period_applicable_statements]).to eq ['Please read the statements and tick if they apply']
      end
    end

    context 'and both rules periods applicable statements are confirmed' do
      before do
        @tenancy.confirmed_first_rules_period_applicable_statements = 'Yes'
        @tenancy.confirmed_second_rules_period_applicable_statements = 'Yes'
      end

      it 'is invalid' do
        expect(@tenancy).not_to be_valid
      end

      it 'has appropriate error message' do
        @tenancy.valid?
        expect(@tenancy.errors[:confirmed_first_rules_period_applicable_statements]).to eq ['leave blank as you specified original tenancy agreement was made on or after 28 February 1997']
        expect(@tenancy.errors[:confirmed_second_rules_period_applicable_statements]).to eq []
      end
    end

  end

end
