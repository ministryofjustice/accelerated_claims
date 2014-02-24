class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  def text_field_row(attribute, options={})
    row_input options[:class], options[:input_class], attribute, @object, self, :text_field, options[:label]
  end

  def text_area_row(attribute, options={})
    row_input options[:class], options[:input_class], attribute, @object, self, :text_area, options[:label]
  end

  def row css_selector, attribute, model
    div = "div.row#{css_selector}"
    div += '.error' if model.errors.messages.key?(attribute)

    @template.haml_tag div do
      yield attribute, presence_required?(attribute, model)
    end
  end

  def fieldset css_selector, attribute, model
    fieldset = "fieldset#{css_selector}"
    fieldset += '.error' if model.errors.messages.key?(attribute)

    @template.haml_tag fieldset do
      yield
    end
  end

  private

  def row_input css_selector, input_class, attribute, model, form, input, label=nil
    css = "row #{css_selector.gsub('.',' ')}"
    css += ' error' if model.errors.messages.key?(attribute)

    @template.surround("<div class='#{css}'>".html_safe,"</div>".html_safe) do
      labelled_input attribute, input_class, form, input, presence_required?(attribute, model), label
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

  def presence_required? attribute, model
    model.class.validators_on(attribute).any? {|v| v.is_a?(ActiveModel::Validations::PresenceValidator)}
  end

end
