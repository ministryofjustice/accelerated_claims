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
    set_class_and_id attribute, options

    options[:choice] ||= {'Yes'=>'Yes', 'No'=>'No'}

    fieldset_tag label_for(attribute, legend), options do
      @template.surround("<div class='options'>".html_safe, "</div>".html_safe) do
        options[:choice].map do |label, choice|
          radio_button_row(attribute, label, choice)
        end.join("\n")
      end
    end
  end

  def row attribute, options={}
    @template.haml_tag haml_tag_text('div row', attribute, options) do
      yield
    end
  end

  def fieldset attribute, options={}
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

  private

  def fieldset_tag(legend = nil, options = {}, &block)
    if options.has_key?(:id)
      id = options.delete(:id)
    else
      id = '_' + SecureRandom.hex(20)
    end

    legend_options = {:id => id}
    options[:"aria-describedby"] = id

    output = tag(:fieldset, options, true)
    output.safe_concat(content_tag(:h3, legend, legend_options)) unless legend.blank?
    output.concat(capture(&block)) if block_given?
    output.safe_concat("</fieldset>")
  end

  def set_class_and_id attribute, options
    options[:class] = css_for(attribute, options)
    options[:id] = id_for(attribute) unless id_for(attribute).blank?
  end

  def id_for attribute
    error_for?(attribute) ? error_id_for(attribute) : ''
  end

  def radio_button_row attribute, label, choice
    label = label.sub(/^([A-Z])/) { |letter| letter.downcase }

    @template.surround("<div class='row'>".html_safe, "</div>".html_safe) do
      [
        radio_button(attribute, choice),
        label(attribute, label.html_safe, value: choice)
      ].join("\n")
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

    if (input == :text_field)
      if max_length = max_length(attribute)
        input_options.merge!(maxlength: max_length)
      end
    end

    value = send(input, attribute, input_options)

    [ label, value ].join("\n").html_safe
  end

  def label_for attribute, label
    label ||= attribute.to_s.humanize
    required = presence_required?(attribute)
    label = %Q|#{label}<span class="req">*</span>| if required

    label = %Q|#{label} #{error_span(attribute)}| if error_for? attribute

    label.html_safe
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
          @object.send(conditional)
        elsif conditional = v.options[:unless]
          !@object.send(conditional)
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
        false
      end
    else
      required
    end
  end

end
