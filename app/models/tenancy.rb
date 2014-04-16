class Tenancy < BaseClass

  ASSURED = 'assured'
  SECURE  = 'secure'

  attr_accessor :tenancy_type
  validates :tenancy_type, presence: { message: 'must be selected' }, inclusion: { in: ['demoted', 'assured'] }

  attr_accessor :assured_shorthold_tenancy_type
  attr_accessor :start_date
  attr_accessor :latest_agreement_date
  attr_accessor :agreement_reissued_for_same_property
  attr_accessor :agreement_reissued_for_same_landlord_and_tenant
  attr_accessor :assured_shorthold_tenancy_notice_served_by
  attr_accessor :assured_shorthold_tenancy_notice_served_date
  attr_accessor :original_assured_shorthold_tenancy_agreement_date

  attr_accessor :demotion_order_date
  attr_accessor :demotion_order_court
  attr_accessor :previous_tenancy_type

  attr_accessor :applicable_statements_1
  attr_accessor :applicable_statements_2
  attr_accessor :applicable_statements_3
  attr_accessor :applicable_statements_4
  attr_accessor :applicable_statements_5
  attr_accessor :applicable_statements_6

  # with_options if: :latest_agreement_date, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] } do |tenancy|
  #   tenancy.validates :agreement_reissued_for_same_property
  #   tenancy.validates :agreement_reissued_for_same_landlord_and_tenant
  # end

  after_validation :remove_shorthold_tenancies_radio_selection_if_demoted
  after_validation :remove_previous_tenancy_radio_selection_if_not_demoted

  DEMOTED_FIELDS = [:demotion_order_date,
      :demotion_order_court,
      :previous_tenancy_type]

  ONE_TENANCY_FIELDS = [:start_date]

  MULTIPLE_TENANCY_FIELDS = [:original_assured_shorthold_tenancy_agreement_date,
      :latest_agreement_date,
      :agreement_reissued_for_same_property,
      :agreement_reissued_for_same_landlord_and_tenant]

  ASSURED_TENANCY_FIELDS = [:assured_shorthold_tenancy_type,
      :assured_shorthold_tenancy_notice_served_by,
      :assured_shorthold_tenancy_notice_served_date]

  STATEMENTS_FIELDS = [:applicable_statements_1,
      :applicable_statements_2,
      :applicable_statements_3,
      :applicable_statements_4,
      :applicable_statements_5,
      :applicable_statements_6]

  with_options if: :demoted_tenancy? do |t|
    t.validates :demotion_order_date, presence: { message: 'must be selected' }
    t.validates :demotion_order_court, presence: { message: 'must be provided' }, length: { maximum: 40 }
    t.validates :previous_tenancy_type, presence: { message: 'must be selected' }, inclusion: { in: ['assured', 'secure'] }

    t.validates *(ASSURED_TENANCY_FIELDS + ONE_TENANCY_FIELDS + MULTIPLE_TENANCY_FIELDS),
      absence: { message: 'leave blank as you specified tenancy is demoted' }

    t.validates *STATEMENTS_FIELDS, inclusion: { in: ['No'], message: 'must be unchecked if tenancy is demoted' }
  end

  with_options if: :assured_tenancy? do |t|
    t.validates :assured_shorthold_tenancy_type, presence: { message: 'must be selected' }, inclusion: { in: ['one', 'multiple'] }
    t.validates :assured_shorthold_tenancy_notice_served_by, length: { maximum: 70 }

    t.validates *DEMOTED_FIELDS,
      absence: { message: 'leave blank as you specified tenancy is not demoted' }
  end

  with_options if: :one_tenancy_agreement? do |t|
    t.validates :start_date, presence: { message: 'must be selected' }
    t.validates_with DateValidator, fields: [:start_date]

    t.validates *MULTIPLE_TENANCY_FIELDS,
      absence: { message: 'must be blank if one tenancy agreement'}
  end

  with_options if: :multiple_tenancy_agreements? do |t|
    t.validates :original_assured_shorthold_tenancy_agreement_date, presence: { message: 'must be selected' }
    t.validates :latest_agreement_date, presence: { message: 'must be selected' }
    t.validates :agreement_reissued_for_same_property, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }
    t.validates :agreement_reissued_for_same_landlord_and_tenant, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

    t.validates_with DateValidator, fields:
      [:original_assured_shorthold_tenancy_agreement_date, :latest_agreement_date]

    t.validates *ONE_TENANCY_FIELDS,
      absence: { message: "must be blank if more than one tenancy agreement" }
  end

  with_options if: -> tenancy { tenancy.assured_shorthold_tenancy_notice_served_date.present? } do |t|
    t.validates :assured_shorthold_tenancy_notice_served_by, presence: { message: 'must be completed' }
  end

  with_options if: -> tenancy { tenancy.assured_shorthold_tenancy_notice_served_by.present? } do |t|
    t.validates :assured_shorthold_tenancy_notice_served_date, presence: { message: 'must be entered' }
  end

  def only_start_date_present?
    start_date.present? && \
    (latest_agreement_date.blank? &&
     agreement_reissued_for_same_property.blank? &&
     agreement_reissued_for_same_landlord_and_tenant.blank? &&
     assured_shorthold_tenancy_notice_served_by.blank? &&
     assured_shorthold_tenancy_notice_served_date.blank?)
  end

  def demoted_tenancy?
    tenancy_type == 'demoted'
  end

  def assured_tenancy?
    tenancy_type == 'assured'
  end

  def one_tenancy_agreement?
    assured_tenancy? && (assured_shorthold_tenancy_type == "one")
  end

  def multiple_tenancy_agreements?
    assured_tenancy? && (assured_shorthold_tenancy_type == "multiple")
  end

  def as_json
    date = original_assured_shorthold_tenancy_agreement_date.present? ? original_assured_shorthold_tenancy_agreement_date : start_date
    hash = {
      "start_date_day" => day(date),
      "start_date_month" => month(date),
      "start_date_year" => year(date),
      "demoted_tenancy" => format_tenancy_type,
      "agreement_reissued_for_same_landlord_and_tenant" => agreement_reissued_for_same_landlord_and_tenant,
      "agreement_reissued_for_same_property" => agreement_reissued_for_same_property,
      "assured_shorthold_tenancy_notice_served_by" => assured_shorthold_tenancy_notice_served_by,
      "latest_agreement_date_day" => day(latest_agreement_date),
      "latest_agreement_date_month" => month(latest_agreement_date),
      "latest_agreement_date_year" => year(latest_agreement_date),
      'demotion_order_court' => short_court_name,
      'applicable_statements_1' => applicable_statements_1,
      'applicable_statements_2' => applicable_statements_2,
      'applicable_statements_3' => applicable_statements_3,
      'applicable_statements_4' => applicable_statements_4,
      'applicable_statements_5' => applicable_statements_5,
      'applicable_statements_6' => applicable_statements_6,
      'previous_tenancy_type' => previous_tenancy_type
    }

    split_date(:demotion_order_date, hash)
    split_date(:assured_shorthold_tenancy_notice_served_date, hash)
    split_date(:original_assured_shorthold_tenancy_agreement_date, hash)
    hash
  end

  private

  def format_tenancy_type
    tenancy_type == "demoted" ? "Yes" : "No"
  end

  def short_court_name
    demotion_order_court.to_s.sub(/ County Court/,'')
  end

  def remove_shorthold_tenancies_radio_selection_if_demoted
    if demoted_tenancy? && !errors.blank?
      self.assured_shorthold_tenancy_type = nil
    end
  end

  def remove_previous_tenancy_radio_selection_if_not_demoted
    if assured_tenancy? && !errors.blank?
      self.previous_tenancy_type = nil
    end
  end
end
