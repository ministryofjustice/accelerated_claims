# -*- coding: utf-8 -*-
class Checklist
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
    when 'No'
      (@json['tenancy_previous_tenancy_type'] == 'assured') ? multiple_assured_tenancies : single_assured_tenancy
    when 'Yes'
      demoted_tenancy
    end
  end

  def multiple_assured_tenancies
    @checklist = "• the first tenancy agreement marked - 'A'\n• the current tenancy agreement marked - 'A1'\n"
  end

  def single_assured_tenancy
    @checklist = "• the tenancy agreement marked 'A'\n"
  end

  def demoted_tenancy
    @checklist = "• the most recent tenancy agreement - marked 'A'\n• the demotion order - marked 'B'"
  end
end
