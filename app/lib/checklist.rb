@@checklist_names = ['tenancy', 'notice', 'license', 'deposit']
@@checklist_names.each {|checklist_name| require "checklist/#{checklist_name}_checklist"}

class Checklist
  def initialize(json)
    @json = json
  end

  def add
    @@checklist_names.each do |ch_name|
      klass = "#{ch_name.capitalize}Checklist".constantize
      klass.new(@json).add
    end
  end
end
