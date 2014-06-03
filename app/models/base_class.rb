class BaseClass
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations::Callbacks

  after_validation :remove_not_included_in_list_error


  @@valid_month_names = %w{ january jan february feb march mar april apr may june jun july jul august aug september sep october oct november nov december dec }

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
      day         = value[0][:value]
      month       = value[1][:value]
      year        = value[2][:value]
      date_string = [day, month, year].join('-')

      # This to cater for the fact that Date.parse will parse any invalid month name to june (Date.parse('23-xxxx-2014') => #<Date: 2014-06-15 ((2456824j,0s,0n),+0s,2299161j)>)
      if !month.is_a?(Fixnum) && month !~ /^[0-9]{1,2}$/  && !@@valid_month_names.include?(month.downcase) 
        date = InvalidDate.new( date_string )
      else
        date = begin
                 Date.parse( date_string )
               rescue
                 InvalidDate.new( date_string )
               end
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
  @@earliest_possible_date = Date.new(1989, 1, 15)
  def validate(record)
    options[:fields].each do |field|
      date = record.send(field)
      next if date.nil?
      if date.is_a?(InvalidDate)
        record.errors.add(field, 'is invalid date')
      elsif date.blank?
        record.errors.add(field, 'cannot be blank')
      elsif date < @@earliest_possible_date
        record.errors.add(field, 'Incorrect date: you can only use this form with an assured shorthold tenancy (introduced 15 January 1989)')
      elsif date > Date.today
        record.errors.add(field, 'cannot be later than current date')
      end
    end
  end
end


