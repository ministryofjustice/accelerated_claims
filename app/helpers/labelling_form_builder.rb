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

  def moj_date_fieldset attribute, legend, options = {}, explanatory_text = nil
    df = MojDateFieldset.new(self, attribute, legend, options, explanatory_text)
    df.emit
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

  

  

  def radio_button_row attribute, label, choice
    input = radio_button(attribute, choice)
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
