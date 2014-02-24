class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  def text_field_row(attribute, options={})
    row_input options[:class], options[:input_class], attribute, @object, self, :text_field, options[:label]
  end

  def text_area_row(attribute, options={})
    row_input options[:class], options[:input_class], attribute, @object, self, :text_area, options[:label]
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

  def haml_tag_text tag, attribute, options
    tag += " #{options[:class]}" if options[:class]
    tag += ' error' if @object.errors.messages.key?(attribute)
    haml_tag_text = tag.squeeze(' ').strip.gsub(' ','.')
  end

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
