class MojDateFieldset

  def initialize(form, attribute, legend, options)
    @form             = form
    @attribute        = attribute
    @legend           = legend
    @options          = options
    # @fieldset_options = {}
    # @day_options      = {}
    # @month_options    = {}
    # @year_options     = {}
  end


 
  def emit
    @form.set_class_and_id @attribute, @options
    @form.fieldset_tag @form.label_for(@attribute, @legend), @options do
      
      date = @form.object.send(@attribute)
      date = nil if date.is_a?(InvalidDate)
      
      @form.fields_for(@attribute, date) do |date_form|
        obj_name   = @form.object.class.to_s.underscore
        day_id     = "claim_#{obj_name}_#{@attribute}_3i"
        month_id   = "claim_#{obj_name}_#{@attribute}_2i"
        year_id    = "claim_#{obj_name}_#{@attribute}_1i"
        day_name   = "claim[#{obj_name}][#{@attribute}(3i)]"
        month_name = "claim[#{obj_name}][#{@attribute}(2i)]"
        year_name  = "claim[#{obj_name}][#{@attribute}(1i)]"

        default_day_options = { maxlength: 2, 
                                id: day_id,   
                                name: day_name,   
                                class: 'moj-date-day', 
                                placeholder: 'DD'
                              }
        default_month_options = { maxlength: 2, 
                                id: month_id,   
                                name: month_name,   
                                class: 'moj-date-month', 
                                placeholder: 'MM'
                              }
        default_year_options = { maxlength: 2, 
                                id: year_id,   
                                name: year_name,   
                                class: 'moj-date-year', 
                                placeholder: 'DD'
                              }
        day       = date_form.text_field(:day, default_day_options)              
                                          
        month     = date_form.text_field(:long_monthname,   
                                          maxlength: 9, 
                                          id: month_id, 
                                          name: month_name, 
                                          class: merge_css_class('moj-date-month', @options[:month]),  
                                          placeholder: 'MM')
        year      = date_form.text_field(:year,             
                                          maxlength: 4, 
                                          id: year_id,  
                                          name: year_name,  
                                          class: merge_css_class('moj-date-year', @options[:year]),
                                          placeholder: 'YYYY')
        "#{day}&nbsp;#{month}&nbsp#{year}".html_safe
      end
    end
  end

  private


  # def validate_options
  #   @options.keys.each do |key|
  #     case key
  #     when :fieldset
  #       @fieldset_options = @options[:fieldset]
  #     when :day
  #       @day_options = @options[:day]
  #     when :month
  #       @month_options = @options[:month]
  #     when :year
  #       @year_options = @options[:year]
  #     else
  #       raise ArgumentError.new("Invalid key for options: #{key.inspect}")
  #     end
  #   end
  # end


  # takes a hash of html options and merges in any css classes that are provided as strings
  def merge_css_class(css_class, options)
    if options.nil? || options[:class].nil? || options[:class].blank?
      css_class
    else
      "#{css_class} #{options[:class]}"
    end
  end
end