class Checklist
  def initialize(json)
    @json = json
  end

  def add
    ['tenancy', 'notice', 'license', 'deposit'].each do |ch_name|
      checklist = "#{ch_name.capitalize}Checklist".constantize
      checklist.new(@json).add
    end
  end
end
