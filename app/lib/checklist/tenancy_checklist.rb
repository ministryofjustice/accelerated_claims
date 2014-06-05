class TenancyChecklist
  def initialize(json)
    @json = json
    @checklist = ""
  end

  def add
    add_tenancy
    @json['required_documents'] = @checklist
    @json
  end

  private

  def add_tenancy
    case @json['tenancy_demoted_tenancy']
    when 'Yes'
      demoted_tenancy_text
    when 'No'
      (@json['tenancy_assured_shorthold_tenancy_type'] == 'multiple') ? multiple_assured_tenancy_text : one_assured_tenancy_text
      optional_tenancy_section
    end
  end

  def multiple_assured_tenancy_text
    @checklist = "- the first tenancy agreement marked - 'A'\n- the current tenancy agreement marked - 'A1'\n\n"
  end

  def one_assured_tenancy_text
    @checklist = "- the tenancy agreement marked 'A'\n\n"
  end

  def demoted_tenancy_text
    @checklist = "- the most recent tenancy agreement - marked 'A'\n- the demotion order - marked 'B'\n\n"
  end

  def optional_tenancy_section
    optional_text if (@json['tenancy_assured_shorthold_tenancy_notice_served_by'].present? && notice_date_present?)
  end

  def notice_date_present?
    @json['tenancy_assured_shorthold_tenancy_notice_served_date_day'].present? &&
      @json['tenancy_assured_shorthold_tenancy_notice_served_date_month'].present? &&
      @json['tenancy_assured_shorthold_tenancy_notice_served_date_year'].present?
  end

  def optional_text
    @checklist.concat "- the notice stating defendants would have an assured shorthold tenancy agreement (given before they moved in) - marked 'B'
- proof this notice was given - marked 'B1'\n\n"
  end
end
