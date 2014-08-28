class InvalidDate

  attr_reader :day, :long_monthname, :year

  def initialize(date_string)
    puts "++++++ DEBUG date string #{date_string} ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    
    @date_string    = date_string
    parts           = @date_string.split('-')
    @day            = parts[0]
    @long_monthname = parts[1]
    @year           = parts[2]
    pp self
  end


  def ==(other)
    @day == other.day && @long_monthname = other.long_monthname && @year = other.year
  end


  def to_s
    @date_string
  end
  
end