module ApplicationHelper

  def row css_selector, field, model
    div = "div.row#{css_selector}"
    div += '.error' if model.errors.messages.key?(field)

    haml_tag div do
      yield field, presence_required?(field, model)
    end
  end

  def fieldset css_selector, field, model
    fieldset = "fieldset#{css_selector}"
    fieldset += '.error' if model.errors.messages.key?(field)

    haml_tag fieldset do
      yield
    end
  end

  def row_text_area css_selector, field, model, form
    row_input css_selector, field, model, form, :text_area
  end

  def row_text_field css_selector, field, model, form
    row_input css_selector, field, model, form, :text_field
  end

  def row_input css_selector, input_class, field, model, form, input, label=nil
    css = "row #{css_selector.gsub('.',' ')}"
    css += ' error' if model.errors.messages.key?(field)

    surround("<div class='#{css}'>".html_safe,"</div>".html_safe) do
      labelled_input field, input_class, form, input, presence_required?(field, model), label
    end
  end

  def labelled_input field, input_class, form, input, required, label=nil
    label ||= field
    raw [ form.label(field, label_for(label, required)), form.send(input,field, class: input_class) ].join("\n")
  end

  def label_for field, required
    label = field.to_s.humanize
    label = %Q|#{label}<span class="req">*</span>| if required
    label.html_safe
  end

  def presence_required? field, model
    model.class.validators_on(field).any? {|v| v.is_a?(ActiveModel::Validations::PresenceValidator)}
  end

end
