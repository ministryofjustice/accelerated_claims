# -*- coding: utf-8 -*-
describe Tenancy, :type => :model do

  include TenancyHelper

  context "when 'assured'" do
    before do
      @tenancy = assured_tenancy
    end

    context 'one tenancy agreement' do
      context 'starting in 1st rules period' do
        before { @tenancy.start_date = Tenancy::RULES_CHANGE_DATE - 1 }

        include_examples 'confirm 1st rules period applicable statements'
      end

      context 'starting in 2nd rules period' do
        before { @tenancy.start_date = Tenancy::RULES_CHANGE_DATE }

        include_examples 'confirm 2nd rules period applicable statements'
      end
    end
  end

end
