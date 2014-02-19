module ApplicationHelper

  def row css_selector, field, model
    div = "div.row#{css_selector}"
    div += '.error' if model.errors.messages.key?(field)

    haml_tag div do
      yield
    end
  end

end
