class NoticeChecklist
  def initialize(json)
    @json = json
  end

  def add
    add_notice
    @json
  end

  private

  def add_notice
    checklist = "- the notice you gave to the defendant to leave the property - marked 'C'\n\n- proof the notice was served - marked 'C1'\n\n"
    @json['required_documents'] = @json['required_documents'].concat checklist
  end
end
