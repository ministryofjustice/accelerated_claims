class InvalidDate

  attr_reader :day, :long_monthname, :year, :month

  def initialize(date_string)
    @date_string    = date_string
    parts           = @date_string.split('-')
    @day            = parts[0]
    @long_monthname = parts[1]
    @month          = parts[1]
    @year           = parts[2]
  end


  def ==(other)
    @day == other.day && @long_monthname == other.long_monthname && @year == other.year
  end


  def to_s
    @date_string
  end
  
end