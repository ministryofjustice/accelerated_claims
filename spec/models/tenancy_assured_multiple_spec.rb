# -*- coding: utf-8 -*-
describe Tenancy, :type => :model do

  include TenancyHelper

  context "when 'assured' multiple tenancy agreements" do
    before do
      @tenancy = assured_tenancy(
          assured_shorthold_tenancy_type: 'multiple',
          latest_agreement_date: Date.parse('2013-01-01'),
          agreement_reissued_for_same_property: 'Yes',
          agreement_reissued_for_same_landlord_and_tenant: 'Yes',
          start_date: '')
    end

    context 'starting in 1st rules period' do
      before do
        @tenancy.original_assured_shorthold_tenancy_agreement_date = Tenancy::RULES_CHANGE_DATE - 365
      end

      context 'and latest agreement starting in 1st rules period' do
        before do
          @tenancy.latest_agreement_date = Tenancy::RULES_CHANGE_DATE - 1
        end

        include_examples 'confirm 1st rules period applicable statements'
      end

      context 'and latest agreement starting in 2nd rules period' do
        before do
          @tenancy.latest_agreement_date = Tenancy::RULES_CHANGE_DATE
        end

        include_examples 'confirm both rules periods applicable statements'
      end
    end

    context 'starting in 2nd rules period' do
      before do
        @tenancy.original_assured_shorthold_tenancy_agreement_date = Tenancy::RULES_CHANGE_DATE
      end

      include_examples 'confirm only 2nd rules period applicable statements'
    end
  end

end
