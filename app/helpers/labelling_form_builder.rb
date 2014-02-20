class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  def text_field_row(attribute, options={})
    @template.row_input options[:class], options[:input_class], attribute, @object, self, :text_field, options[:label]
  end

  def text_area_row(attribute, options={})
    @template.row_input options[:class], options[:input_class], attribute, @object, self, :text_area, options[:label]
  end
end
