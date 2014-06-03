require 'checklist/tenancy_checklist'
require 'checklist/notice_checklist'
require 'checklist/license_checklist'
require 'checklist/deposit_checklist'

class Checklist
  def initialize(json)
    @json = json
  end

  def add
    add_tenancy_checklist
    add_notice_checklist
    add_license_checklist
    add_deposit_checklist
  end

  private

  def add_tenancy_checklist
    TenancyChecklist.new(@json).add
  end

  def add_notice_checklist
    NoticeChecklist.new(@json).add
  end

  def add_license_checklist
    LicenseChecklist.new(@json).add
  end

  def add_deposit_checklist
    DepositChecklist.new(@json).add
  end
end
