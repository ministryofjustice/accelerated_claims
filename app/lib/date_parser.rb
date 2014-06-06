# DateParser - does a better job of parsing dates coming in from form fields that Date.DateParser


class DateParser

  @@short_month_names = %w{ jan feb mar apr may jun jul aug sep oct nov dec }
  @@long_month_names  = %w{ january february march april may june july august september october november december }

  # instantigate a date parser.  Expects values to be passed in and array of three hashes in the form:
  #
  # [
  #   {:part=>"date_served(3i)", :value=>"1"},
  #   {:part=>"date_served(2i)", :value=>"4"},
  #   {:part=>"date_served(1i)", :value=>"99"}
  # ]
  #
  def initialize(values)
    @values           = values
    @day              = ''
    @month            = ''
    @year             = ''
    @normalized_month = ''
    @date             = nil
  end


  # parses the values supplied to .new
  # returns a Date, InvalidDate, or nil if all three values blank.
  #
  def parse
    @values.each do |value_hash|
      extract_value(value_hash)
    end
    
    begin
      if @day.blank? && @month.blank? && @year.blank?
        @date = nil
      else
        check_no_blanks
        normalize_month
        date_string = "#{@day}-#{@normalized_month}-#{@year}"
        @date = Date.parse(date_string)
      end
    rescue
      @date = InvalidDate.new("#{@day}-#{@month}-#{@year}")
    end
    @date
  end





  private 

  def normalize_month
    if valid_fixnum?(@month) || valid_numeric_string?(@month)
      @normalized_month = @@short_month_names[@month.to_i - 1]
    else
      if @@short_month_names.include?(@month.downcase) || @@long_month_names.include?(@month.downcase)
        @normalized_month = @month
      else
        raise         # will be trapped and an InvalidDAte object will be returned.
      end
    end
  end

  # raise if any of the fields are balnk - this will tigger an InvalidDate to be returned from parse()
  def check_no_blanks
    [ @day, @month, @year ].each { |f| raise if f.blank? }
  end



  def valid_fixnum?(m)
    m.is_a?(Fixnum) && m > 0 && m < 13
  end

  def valid_numeric_string?(m)
    m =~ /^[0-9]{1,2}$/  && m.to_i < 13
  end


  def extract_value(value_hash)
    if value_hash[:part] =~ /\(1i\)$/
      @year = value_hash[:value]
    elsif value_hash[:part] =~ /\(2i\)$/
      @month = value_hash[:value]
    elsif value_hash[:part] =~ /\(3i\)$/
      @day = value_hash[:value]
    else
      raise ArgumentError.new "DateParser expects to find hash with :part name ending (1i), (2i) or (3i)"
    end
  end

end
  