class Tenancy < BaseClass

  attr_accessor :demoted_tenancy

  attr_accessor :start_date
  attr_accessor :latest_agreement_date
  attr_accessor :reissued_for_same_property
  attr_accessor :reissued_for_same_landlord_and_tenant
  attr_accessor :assured_shorthold_tenancy_notice_served_by
  attr_accessor :assured_shorthold_tenancy_notice_served_date

  validates :start_date, presence: { message: 'must be entered' }, unless: :demoted_tenancy

  with_options if: :latest_agreement_date, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] } do |tenancy|
    tenancy.validates :reissued_for_same_property
    tenancy.validates :reissued_for_same_landlord_and_tenant
  end

  def as_json
    json = super
    json.delete('demoted_tenancy')
    json = split_date :start_date, json
    json = split_date :latest_agreement_date, json
    json = split_date :assured_shorthold_tenancy_notice_served_date, json
    json['agreement_reissued_for_same_property'] = json.delete('reissued_for_same_property')
    json['agreement_reissued_for_same_landlord_and_tenant'] = json.delete('reissued_for_same_landlord_and_tenant')
    json
  end
end
