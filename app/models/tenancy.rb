class Tenancy < BaseClass

  attr_accessor :start_date
  validates :start_date, presence: true

  attr_accessor :latest_agreement_date

  attr_accessor :agreement_reissued_for_same_property
  validates :agreement_reissued_for_same_property, inclusion: { in: [true, false] }

  attr_accessor :agreement_reissued_for_same_landlord_and_tenant
  validates :agreement_reissued_for_same_landlord_and_tenant, inclusion: { in: [true, false] }
end
