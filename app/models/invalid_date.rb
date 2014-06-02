class InvalidDate

  attr_reader :day, :long_monthname, :year

  def initialize(date_string)
    parts = date_string.split('-')
    @day = parts[2]
    @long_monthname = parts[1]
    @year = parts[0]
  end
  
end