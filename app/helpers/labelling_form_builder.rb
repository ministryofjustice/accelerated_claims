class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def text_field_row(attribute, options={})
    row_input attribute, :text_field, options
  end

  def text_area_row(attribute, options={})
    row_input attribute, :text_area, options
  end

  def moj_date_fieldset attribute, legend, options={}
    df = MojDateFieldset.new(self, attribute, legend, options)
    df.emit
  end


  # provides html for day, month, year text boxes
  # @param [Symbol] attribute - The atttribute on the model use to populate the fields and received data from the fields (normally a Date object)
  # @param [String] legend = The title to be displayed above the fields
  # @options [Hash] html options to be added to the elements.  This is specified as a hash of hashes, the outer hash being keyed by:
  #  - fieldset
  #  - day
  #  - month
  #  - date
  #  
  # e.g. form.moj_date_fieldset(:expiry_date, "When did it expire?", {fieldset: {class: 'date-picker conditional'}, day: {placeholder: 'dd'}})
  # def moj_date_fieldset attribute, legend, options={}
  #   set_class_and_id attribute, options
  #   fieldset_tag label_for(attribute, legend), options do
  #     date = @object.send(attribute)
  #     date = nil if date.is_a?(InvalidDate)
      
  #     fields_for(attribute, date) do |date_form|
  #       obj_name   = @object.class.to_s.underscore
  #       day_id     = "claim_#{obj_name}_#{attribute}_3i"
  #       month_id   = "claim_#{obj_name}_#{attribute}_2i"
  #       year_id    = "claim_#{obj_name}_#{attribute}_1i"
  #       day_name   = "claim[#{obj_name}][#{attribute}(3i)]"
  #       month_name = "claim[#{obj_name}][#{attribute}(2i)]"
  #       year_name  = "claim[#{obj_name}][#{attribute}(1i)]"

  #       day       = date_form.text_field(:day,              
  #                                         maxlength: 2, 
  #                                         id: day_id,   
  #                                         name: day_name,   
  #                                         class: merge_css_class('moj-date-day', options), 
  #                                         placeholder: 'DD')
  #       month     = date_form.text_field(:long_monthname,   
  #                                         maxlength: 9, 
  #                                         id: month_id, 
  #                                         name: month_name, 
  #                                         class: merge_css_class('moj-date-month', options),  
  #                                         placeholder: 'MM')
  #       year      = date_form.text_field(:year,             
  #                                         maxlength: 4, 
  #                                         id: year_id,  
  #                                         name: year_name,  
  #                                         class: merge_css_class('moj-date-year', options),
  #                                         placeholder: 'YYYY')
  #       "#{day}&nbsp;#{month}&nbsp#{year}".html_safe
  #     end
  #   end
  # end


  #   # takes a hash of html options and merges in any css classes that are provided as strings
  # def merge_css_class(css_class, options)
  #   if options[:class].nil? || options[:class].blank?
  #     css_class
  #   else
  #     "#{css_class} #{options[:class]}"
  #   end
  # end



  def date_select_field_set attribute, legend, options={}
    set_class_and_id attribute, options

    fieldset_tag label_for(attribute, legend), options do
      @template.surround("<div class='row'>".html_safe, "</div>".html_safe) do
        if @object.send(attribute).is_a?(InvalidDate)
          @object.send("#{attribute}=", nil) # nil date to avoid exception on date_select call
        end
        date_select(attribute, options[:date_select_options])
      end
    end
  end

  def radio_button_fieldset attribute, legend, options={}
    virtual_pageview = options[:data] ? options[:data].delete('virtual-pageview') : nil

    set_class_and_id attribute, options

    options[:choice] ||= {'Yes'=>'Yes', 'No'=>'No'}

    fieldset_tag label_for(attribute, legend), options do
      @template.surround("<div class='options'>".html_safe, "</div>".html_safe) do
        options[:choice].map do |label, choice|
          radio_button_row(attribute, label, choice, virtual_pageview)
        end.join("\n")
      end
    end
  end

  def row attribute, options={}
    @template.haml_tag haml_tag_text('div option', attribute, options) do
      yield
    end
  end

  def fieldset attribute, options={}
    options.delete(:id) unless options[:id].present?
    @template.haml_tag haml_tag_text('fieldset', attribute, options) do
      yield
    end
  end

  def error_for? attribute
    @object.errors.messages.key?(attribute) && !@object.errors.messages[attribute].empty?
  end

  def error_span attribute
    message = @object.errors.messages[attribute][0]
    @template.surround(" <span class='error'>".html_safe, "</span>".html_safe) { message }
  end

  def error_id_for attribute
    "#{@object_name.tr('[]','_')}_#{attribute}_error".squeeze('_')
  end

  def id_for attribute, default=nil
    error_for?(attribute) ? error_id_for(attribute) : (default || '')
  end

  def labelled_check_box attribute, label, yes='Yes', no='No', options={}
    hidden_input = check_box_input_hidden attribute, options, yes, no

    labeled_input = label(attribute) do
      check_box_input(attribute, options, yes, no) + label
    end

    list = [hidden_input, labeled_input]

    if error_for?(attribute)
      list << error_span(attribute)
    end

    list.join("\n").html_safe
  end


  def set_class_and_id attribute, options
    options[:class] = css_for(attribute, options)
    options[:id] = id_for(attribute) unless id_for(attribute).blank?
  end

  def label_for attribute, label
    label ||= attribute.to_s.humanize

    label = %Q|#{label} #{error_span(attribute)}| if error_for? attribute

    label.html_safe
  end

  def fieldset_tag(legend = nil, options = {}, &block)
    if options.has_key?(:id)
      id = options.delete(:id)
    else
      id = '_' + SecureRandom.hex(20)
    end

    legend_options = {:id => id, :class => 'legend'}
    options[:"aria-describedby"] = id

    options_for_fieldset = {}.merge(options)
    options_for_fieldset.delete(:choice)
    options_for_fieldset.delete(:date_select_options)

    output = tag(:fieldset, options_for_fieldset, true)
    output.safe_concat(content_tag(:span, legend, legend_options)) unless legend.blank?
    output.concat(capture(&block)) if block_given?
    output.safe_concat("</fieldset>")
  end



  private

  def check_box_input attribute, options, yes, no
    html = check_box(attribute, options, yes, no)
    html.gsub!(/<[^<]*type="hidden"[^>]*>/,'')
    html.html_safe
  end

  def check_box_input_hidden attribute, options, yes, no
    html = check_box(attribute, options, yes, no)
    html.gsub!(/.*(<[^<]*type="hidden"[^>]*>).*/, '\1')
    html.html_safe
  end

  def radio_button_row attribute, label, choice, virtual_pageview
    input = if virtual_pageview
              radio_button(attribute, choice, data: { 'virtual_pageview' => virtual_pageview })
            else
              radio_button(attribute, choice)
            end
    id = input[/id="([^"]+)"/,1]

    @template.surround("<div class='option'>".html_safe, "</div>".html_safe) do
      @template.surround("<label for='#{id}'>".html_safe, "</label>".html_safe) do
        [
          input,
          label
        ].join("\n")
      end
    end

  end

  def css_for attribute, options
    css = ''
    css += " #{options[:class]}" if options[:class].present?
    css += ' error' if error_for?(attribute)
    css.strip
  end

  def haml_tag_text tag, attribute, options
    tag += " #{css_for(attribute, options)}"
    haml_tag_text = tag.squeeze(' ').strip.gsub(' ','.')
  end

  def row_input attribute, input, options
    css = "row #{css_for(attribute, options)}".strip

    id = id_for(attribute).blank? ? '' : "id='#{id_for(attribute)}' "

    @template.surround("<div #{id}class='#{css}'>".html_safe, "</div>".html_safe) do
      input_options = options.merge(class: options[:input_class])
      input_options.delete(:label)
      input_options.delete(:input_class)

      labelled_input attribute, input, input_options, options[:label]
    end
  end

  def labelled_input attribute, input, input_options, label=nil
    label = label(attribute, label_for(attribute, label))

    if max_length = max_length(attribute)
      input_options.merge!(maxlength: max_length)
    end

    value = send(input, attribute, input_options)

    [ label, value ].join("\n").html_safe
  end



  def max_length attribute
    if validator = validators(attribute).detect{|x| x.is_a?(ActiveModel::Validations::LengthValidator)}
      validator.options[:maximum]
    end
  end

  def validators attribute
    @object.class.validators_on(attribute)
  end

  def presence_required? attribute

    required = validators(attribute).any? do |v|
      if v.is_a?(ActiveModel::Validations::PresenceValidator)
        if conditional = v.options[:if]
          if conditional.is_a?(Proc)
            conditional.call(@object)
          else
            @object.send(conditional)
          end
        elsif conditional = v.options[:unless]
          if conditional.is_a?(Proc)
            !conditional.call(@object)
          else
            !@object.send(conditional)
          end
        elsif attribute == :court_fee
          false
        else
          true
        end
      else
        false
      end
    end

    if @object.respond_to?(:validate_presence)
      if @object.validate_presence
        required
      else
        if @object.respond_to?(:first_defendant) && @object.first_defendant
          required
        else
          false
        end
      end
    else
      required
    end
  end

end
