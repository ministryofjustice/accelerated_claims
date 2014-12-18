# Class to generate html for moj_date_fieldset method in LabellingFormBuilder.

class MojDateFieldset

  @@hint      = "For example,&nbsp;&nbsp;"
  @@date_mask = '%d&nbsp;&nbsp;%m&nbsp;&nbsp;%Y'

  @@div_classes = {
    :day            => 'form-group form-group-day',
    :long_monthname => 'form-group form-group-month',
    :year           => 'form-group form-group-year'
  }

  @@div_labels = {
    :day            => 'Day',
    :long_monthname => 'Month',
    :year           => 'Year'
  }

  # @param [LabellingFormBuilder] form : the form builder
  # @param [Symbol] attribute: the name of the attribute to be updated (usually a Date class)
  # @param [String] legend: the legend for the date control
  # @param [Hash] options : HTML options to be passed in.  These options are merged applied to the fieldset and span elements before the
  #  date boxes themselves.  Attributes to be applied to the day, month or year text boxes should be specified as inner hashes with keys
  #  "_day", "_month", "_year" respectively.  Attributes thus specified will be merged with the default attributes.
  # @param [Date] example_date : the date to use as the example in the explanatory text, defaults to today
  # @param [String] explanatory_text : the explanatory text to use if the standard example date isn't to be used (if this is non-nil, the example date is ignored)
  #
  def initialize(form, attribute, legend, options = {}, example_date = Date.today, explanatory_text = nil)
    @form                    = form
    @attribute               = attribute
    @legend                  = legend
    @example_date            = example_date
    @explanatory_text        = explanatory_text || "#{@@hint}#{@example_date.strftime(@@date_mask)}"
    @options                 = options
    @passed_in_day_options   = nil
    @passed_in_month_options = nil
    @passed_in_year_options  = nil
    extract_sub_options
  end

  def emit
    @form.set_class_and_id @attribute, @options
    @options[:hint] = @explanatory_text unless @explanatory_text.nil?

    @form.fieldset_tag @attribute, @legend, @options do

      date = @form.object.send(@attribute)

      @form.fields_for(@attribute, date) do |date_form|
        obj_name   = @form.object.class.to_s.underscore

        default_day_options = { maxlength: 2,
                                id: "claim_#{obj_name}_#{@attribute}_3i",
                                name: "claim[#{obj_name}][#{@attribute}(3i)]",
                                class: 'moj-date-day'
                              }
        default_month_options = { maxlength: 9,
                                id: "claim_#{obj_name}_#{@attribute}_2i",
                                name: "claim[#{obj_name}][#{@attribute}(2i)]",
                                class: 'moj-date-month'
                              }
        default_year_options = { maxlength: 4,
                                id: "claim_#{obj_name}_#{@attribute}_1i",
                                name: "claim[#{obj_name}][#{@attribute}(1i)]",
                                class: 'moj-date-year'
                              }

        html = '<div class="form-date">' +
               div_and_label_for(date_form, :day, default_day_options.merge(@passed_in_day_options)) +
               div_and_label_for(date_form, :long_monthname, default_month_options.merge(@passed_in_month_options)) +
               div_and_label_for(date_form, :year, default_year_options.merge(@passed_in_year_options)) +
               '</div>'
        html.html_safe
      end
    end
  end

  private

  def div_and_label_for(form, attribute, options)
    html = %Q[
      <div class="#{@@div_classes[attribute]}">
        <label for="#{options[:id]}">#{@@div_labels[attribute]}</label>
        #{form.text_field(attribute, options) }
      </div>
    ]
    squash(html)
  end

  def squash(str)
    str.gsub!("\n", "")
    str.gsub!(/\s+/," ")
    str.gsub!(" <", "<")
    str.gsub!("> ", ">")
    str
  end

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