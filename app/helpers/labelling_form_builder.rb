class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  def text_field_row(attribute, options={})
    row_input options[:class], options[:input_class], attribute, @object, self, :text_field, options[:label]
  end

  def text_area_row(attribute, options={})
    row_input options[:class], options[:input_class], attribute, @object, self, :text_area, options[:label]
  end

  def row css_selector, attribute
    div = "div row #{css_selector}"
    div += ' error' if @object.errors.messages.key?(attribute)

    @template.haml_tag div.squeeze(' ').strip.gsub(' ','.') do
      yield attribute, presence_required?(attribute, @object)
    end
  end

  def fieldset attribute, options
    fieldset = "fieldset"
    fieldset += " #{options[:class]}" if options[:class]
    fieldset += ' error' if @object.errors.messages.key?(attribute)

    @template.haml_tag fieldset.squeeze(' ').strip.gsub(' ','.') do
      yield
    end
  end

  private

  def row_input css_selector, input_class, attribute, object, form, input, label=nil
    css = "row #{css_selector.gsub('.',' ')}"
    css += ' error' if object.errors.messages.key?(attribute)

    @template.surround("<div class='#{css}'>".html_safe,"</div>".html_safe) do
      labelled_input attribute, input_class, form, input, presence_required?(attribute, object), label
    end
  end

  def labelled_input attribute, input_class, form, input, required, label=nil
    label ||= attribute
    [ form.label(attribute, label_for(label, required)), form.send(input, attribute, class: input_class) ].join("\n").html_safe
  end

  def label_for attribute, required
    label = attribute.to_s.humanize
    label = %Q|#{label}<span class="req">*</span>| if required
    label.html_safe
  end

  def presence_required? attribute, object
    object.class.validators_on(attribute).any? {|v| v.is_a?(ActiveModel::Validations::PresenceValidator)}
  end

end
