class BaseClass
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations::Callbacks

  after_validation :remove_not_included_in_list_error

  def attributes
    instance_values
  end

  def date_input_format
    "%Y-%m-%d"
  end

  def split_postcode
    if postcode.nil?
      p1, p2 = '', ''
    else
      pcode = UKPostcode.new(postcode)
      p1 = pcode.outcode
      p2 = pcode.incode
    end
    return p1,p2
  end

  def date_string(date_attribute, strftime_format)
    date_attribute.blank? ? '' : date_attribute.strftime(strftime_format)
  end

  def day(date_attribute)
    date_string(date_attribute, '%d')
  end

  def month(date_attribute)
    date_string(date_attribute, '%m')
  end

  def year(date_attribute)
    date_string(date_attribute, '%Y')
  end

  def split_date field, json
    json.delete(field.to_s)
    date = send(field.to_sym)

    json.merge!({
      "#{field}_day" => day(date),
      "#{field}_month" => month(date),
      "#{field}_year" => year(date)
    })
    json
  end

  # this is pretty grim.
  # what it does: turns multipart dates in form submissions into a single Date object
  def initialize fields={}
    if !fields.nil? then
      date_fields = {}

      fields.each do |field, value|
        if field.match( /^(.+)\(.+\)$/ )
          part = Regexp.last_match[1]
          date_fields[part] ||= []
          date_fields[part] << { :part => field, :value => value }
        else
          writer = :"#{field}="
          send( writer, value) if respond_to?(writer)
        end
      end

      date_fields.each { |field, value| set_date field, value }
    end
  end

  private

  def set_date field, value
    values = value.sort_by {|a| a[:part] }.collect {|a| a[:value] }

    if values.all?(&:present?)
      p1 = values[0]
      p2 = ( values[1].size() > 0 ? ( values[1].size() == 1 ? "0#{values[1]}" : values[1] ) : "01" )
      p3 = ( values[2].size() > 0 ? ( values[2].size() == 1 ? "0#{values[2]}" : values[2] ) : "01" )
      date_string = [ p1, p2, p3 ].join( "-" )
      date = begin
               Date.parse( date_string )
             rescue
               InvalidDate.new( date_string )
             end
      send( "#{field}=", date )
    end
  end

  def remove_not_included_in_list_error
    unless errors.empty?
      errors.each do |attribute|
        errors[attribute].delete_if{|m| m == "is not included in the list"}
      end
    end
  end
end

class DateValidator < ActiveModel::Validator
  @@earliest_possible_date = Date.new(1989, 1, 1)
  def validate(record)
    options[:fields].each do |field|
      date = record.send(field)
      next if date.nil?
      if date.is_a?(InvalidDate)
        record.errors.add(field, 'is invalid date')
      elsif date.blank?
        record.errors.add(field, 'cannot be blank')
      elsif date < @@earliest_possible_date
        record.errors.add(field, 'cannot be before 01 Jan 1989')
      elsif date > Date.today
        record.errors.add(field, 'cannot be later than current date')
      end
    end
  end
end

class InvalidDate

  attr_reader :day, :long_monthname, :year

  def initialize(date_string)
    parts = date_string.split('-')
    @day = parts[2]
    @long_monthname = parts[1]
    @year = parts[0]
  end
  
end
