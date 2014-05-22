# Class to generate html for moj_date_fieldset method in LabellingFormBuilder.
# @param [LabellingFormBuilder] form : the form builder
# @param [Symbol] attribute: the name of the attribute to be updated (usually a Date class)
# @param [String] legend: the legend for the date control
# @param [Hash] options : HTML options to be passed in.  These options are merged applied to the fieldset and span elements before the 
#  date boxes themselves.  Attributes to be applied to the day, month or year text boxes should be specified as inner hashes with keys 
#  "_day", "_month", "_year" respectively.  Attributes thus specified will be merged with the default attributes.

class MojDateFieldset

  def initialize(form, attribute, legend, options)
    @form                    = form
    @attribute               = attribute
    @legend                  = legend
    @options                 = options
    @passed_in_day_options   = nil
    @passed_in_month_options = nil
    @passed_in_year_options  = nil
    extract_sub_options
  end


 
  def emit
    @form.set_class_and_id @attribute, @options
    @form.fieldset_tag @form.label_for(@attribute, @legend), @options do
      
      date = @form.object.send(@attribute)
      date = nil if date.is_a?(InvalidDate)
      
      @form.fields_for(@attribute, date) do |date_form|
        obj_name   = @form.object.class.to_s.underscore
        
        default_day_options = { maxlength: 2, 
                                id: "claim_#{obj_name}_#{@attribute}_3i", 
                                name: "claim[#{obj_name}][#{@attribute}(3i)]",   
                                class: 'moj-date-day', 
                                placeholder: 'DD'
                              }
        default_month_options = { maxlength: 9, 
                                id: "claim_#{obj_name}_#{@attribute}_2i",   
                                name: "claim[#{obj_name}][#{@attribute}(2i)]",   
                                class: 'moj-date-month', 
                                placeholder: 'MM'
                              }
        default_year_options = { maxlength: 4, 
                                id: "claim_#{obj_name}_#{@attribute}_1i",   
                                name: "claim[#{obj_name}][#{@attribute}(1i)]",   
                                class: 'moj-date-year', 
                                placeholder: 'YYYY'
                              }
        day       = date_form.text_field(:day, default_day_options.merge(@passed_in_day_options))              
        month     = date_form.text_field(:long_monthname, default_month_options.merge(@passed_in_month_options)) 
        year      = date_form.text_field(:year, default_year_options.merge(@passed_in_year_options))            
        "#{day}&nbsp;#{month}&nbsp#{year}".html_safe
      end
    end
  end

  private


  def extract_sub_options
    @passed_in_day_options   = @options.delete('_day') || {}
    @passed_in_month_options = @options.delete('_month') || {}
    @passed_in_year_options  = @options.delete('_year') || {}
  end


  # takes a hash of html options and merges in any css classes that are provided as strings
  def merge_css_class(css_class, options)
    if options.nil? || options[:class].nil? || options[:class].blank?
      css_class
    else
      "#{css_class} #{options[:class]}"
    end
  end
end