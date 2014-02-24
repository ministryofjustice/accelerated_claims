class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  def text_field_row(attribute, options={})
    row_input attribute, :text_field, options
  end

  def text_area_row(attribute, options={})
    row_input attribute, :text_area, options
  end

  def radio_button_fieldset attribute, legend, options={}
    legend = label_for attribute, legend

    if error_for? attribute
      legend += @template.surround(" <span class='error'>".html_safe, "</span>".html_safe) { @object.errors.messages[attribute][0] }
    end

    options[:class] = css_for(attribute, options)

    options[:choice] ||= {'Yes'=>'Yes', 'No'=>'No'}

    @template.field_set_tag legend, options do
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

  private

  def radio_button_row attribute, label, choice
    @template.surround("<div class='row'>".html_safe, "</div>".html_safe) do
      [
        radio_button(attribute, choice),
        label(attribute, label, value: choice)
      ].join("\n")
    end
  end

  def css_for attribute, options
    css = ''
    css += " #{options[:class]}" if options[:class]
    css += ' error' if error_for?(attribute)
    css
  end

  def error_for? attribute
    @object.errors.messages.key?(attribute)
  end

  def haml_tag_text tag, attribute, options
    tag += " #{css_for(attribute, options)}"
    haml_tag_text = tag.squeeze(' ').strip.gsub(' ','.')
  end

  def row_input attribute, input, options
    css = "row #{css_for(attribute, options)}"

    @template.surround("<div class='#{css}'>".html_safe,"</div>".html_safe) do
      labelled_input attribute, options[:input_class], input, options[:label]
    end
  end

  def labelled_input attribute, input_class, input, label=nil
    [ self.label(attribute, label_for(attribute, label)), self.send(input, attribute, class: input_class) ].join("\n").html_safe
  end

  def label_for attribute, label
    label ||= attribute.to_s.humanize
    required = presence_required?(attribute)
    label = %Q|#{label}<span class="req">*</span>| if required
    label.html_safe
  end

  def presence_required? attribute
    validators = @object.class.validators_on(attribute)
    validators.any? {|v| v.is_a?(ActiveModel::Validations::PresenceValidator)}
  end

end
