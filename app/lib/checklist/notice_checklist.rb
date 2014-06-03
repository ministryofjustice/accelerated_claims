# -*- coding: utf-8 -*-
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
    checklist = "• the section 21 notice that you gave to the defendant - marked 'C'
• proof this notice was given - marked 'C1'"
    @json['required_documents'] = @json['required_documents'].concat checklist
  end
end