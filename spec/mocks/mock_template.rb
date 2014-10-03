class MockTemplate
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper

  attr_accessor :output_buffer

  def surround(start_html, end_html, &block)
    "#{start_html}#{block.call}#{end_html}".html_safe
  end



end
