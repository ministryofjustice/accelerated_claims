class Tenancy < BaseClass

  attr_accessor :tenancy_type
  validates :tenancy_type, presence: { message: 'must be selected' }
  validates :tenancy_type, inclusion: { in: ['demoted', 'assured'] }

  attr_accessor :assured_shorthold_tenancy_type
  attr_accessor :start_date
  attr_accessor :latest_agreement_date
  attr_accessor :reissued_for_same_property
  attr_accessor :reissued_for_same_landlord_and_tenant
  attr_accessor :assured_shorthold_tenancy_notice_served_by
  attr_accessor :assured_shorthold_tenancy_notice_served_date
  attr_accessor :original_assured_shorthold_tenancy_agreement_date

  attr_accessor :demotion_order_date
  attr_accessor :demotion_order_court
  attr_accessor :previous_tenancy_type

  with_options if: :latest_agreement_date, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] } do |tenancy|
    tenancy.validates :reissued_for_same_property
    tenancy.validates :reissued_for_same_landlord_and_tenant
  end

  def only_start_date_present?
    start_date.present? && \
    (latest_agreement_date.blank? &&
     reissued_for_same_property.blank? &&
     reissued_for_same_landlord_and_tenant.blank? &&
     assured_shorthold_tenancy_notice_served_by.blank? &&
     assured_shorthold_tenancy_notice_served_date.blank?)
  end

  %w(demoted assured).each do |meth|
    define_method("#{meth}_tenancy?".to_sym) { tenancy_type == meth }
  end

  with_options if: :demoted_tenancy? do |tenancy|
    tenancy.validates :demotion_order_date, presence: { message: 'must be selected' }
    tenancy.validates :demotion_order_court, presence: { message: 'must be provided' }
    tenancy.validates :previous_tenancy_type, presence: { message: 'must be selected' }
  end

  with_options if: :assured_tenancy? do |tenancy|
    tenancy.validates :assured_shorthold_tenancy_type, presence: { message: 'must be selected' }
    tenancy.validates :assured_shorthold_tenancy_type, inclusion: { in: ['one', 'multiple'] }

    with_options if: :one_tenancy_agreement? do |tenancy|
      tenancy.validates :start_date, presence: { message: 'must be selected' }
      validates_with DateValidator, :fields => [:start_date, :latest_agreement_date]
    end

    with_options if: :multiple_tenancy_agreement? do |tenancy|
      tenancy.validates :original_assured_shorthold_tenancy_agreement_date, presence: { message: 'must be selected' }
      tenancy.validates :reissued_for_same_property, presence: { message: 'must be selected' }
      tenancy.validates :reissued_for_same_property, inclusion: { in: ['yes', 'no'] }
      tenancy.validates :reissued_for_same_landlord_and_tenant, presence: { message: 'must be selected' }
      tenancy.validates :reissued_for_same_landlord_and_tenant, inclusion: { in: ['yes', 'no'] }
    end
  end

  def one_tenancy_agreement?
    assured_shorthold_tenancy_type == "one"
  end

  def multiple_tenancy_agreement?
    assured_shorthold_tenancy_type == "multiple"
  end

  def as_json
    start_date = original_assured_shorthold_tenancy_agreement_date if original_assured_shorthold_tenancy_agreement_date.present?
    {
      "start_date_day" => day(start_date),
      "start_date_month" => month(start_date),
      "start_date_year" => year(start_date),
      "demoted_tenancy" => format_tenancy_type,
      "agreement_reissued_for_same_landlord_and_tenant" => reissued_for_same_landlord_and_tenant,
      "agreement_reissued_for_same_property" => reissued_for_same_property,
      "assured_shorthold_tenancy_notice_served_by" => assured_shorthold_tenancy_notice_served_by,
      "latest_agreement_date_day" => day(latest_agreement_date),
      "latest_agreement_date_month" => month(latest_agreement_date),
      "latest_agreement_date_year" => year(latest_agreement_date),
    }

  end

  def demoted_tenancy= obj
  end

  def demoted_tenancy
    true
  end

  private
  def format_tenancy_type
    tenancy_type == "demoted" ? "Yes" : "No"
  end
end
