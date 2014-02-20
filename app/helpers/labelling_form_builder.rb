class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  def text_field_row(attribute, options={})
    @template.row_input options[:class], attribute, @object, self, :text_field
  end

  def text_area_row(attribute, options={})
    @template.row_input options[:class], attribute, @object, self, :text_area
  end
end
