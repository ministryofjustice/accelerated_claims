class Tenancy < BaseClass

  attr_accessor :tenancy_start_date
  validates :tenancy_start_date, presence: true

  attr_accessor :latest_tenancy_agreement_date

  attr_accessor :tenancy_agreement_reissued_for_same_property
  validates :tenancy_agreement_reissued_for_same_property, inclusion: { in: [true, false] }

  attr_accessor :tenancy_agreement_reissued_for_same_landlord_and_tenant
  validates :tenancy_agreement_reissued_for_same_landlord_and_tenant, inclusion: { in: [true, false] }

end
