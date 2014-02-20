module ApplicationHelper

  def row css_selector, field, model
    div = "div.row#{css_selector}"
    div += '.error' if model.errors.messages.key?(field)

    haml_tag div do
      yield
    end
  end

  def fieldset css_selector, field, model
    fieldset = "fieldset#{css_selector}"
    fieldset += '.error' if model.errors.messages.key?(field)

    haml_tag fieldset do
      yield
    end
  end

  def presence_required? field, model
    model.class.validators_on(field).any? {|v| v.is_a?(ActiveModel::Validations::PresenceValidator)}
  end
end
