class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def text_field_row(attribute, options={})
    row_input attribute, :text_field, options
  end

  def text_area_row(attribute, options={})
    row_input attribute, :text_area, options
  end

  def moj_date_fieldset attribute, legend, options = {}, example_date = Date.today, explanatory_text = nil
    df = MojDateFieldset.new(self, attribute, legend, options, example_date, explanatory_text)
    df.emit
  end

  def date_select_field_set attribute, legend, options={}
    set_class_and_id attribute, options

    fieldset_tag attribute, legend, options do
      @template.surround("<div class='row'>".html_safe, "</div>".html_safe) do
        if @object.send(attribute).is_a?(InvalidDate)
          @object.send("#{attribute}=", nil) # nil date to avoid exception on date_select call
        end
        date_select(attribute, options[:date_select_options])
      end
    end
  end

  # Defaults to "Yes" "No" labels on radio inputs
  def radio_button_fieldset attribute, legend, options={}
    virtual_pageview = options[:data] ? options[:data].delete('virtual-pageview') : nil
    input_class = options.delete(:input_class)

    set_class_and_id attribute, options

    options[:choice] ||= {'Yes'=>'Yes', 'No'=>'No'}

    data_reverse = options.delete(:toggle_fieldset) ? ' data-reverse="true"' : ''

    fieldset_tag attribute, legend, options do
      @template.surround("<div class='options'#{data_reverse}>".html_safe, "</div>".html_safe) do
        options[:choice].map do |label, choice|
          radio_button_row(attribute, label, choice, virtual_pageview, input_class)
        end.join("\n")
      end
    end
  end

  def row attribute, options={}
    @template.haml_tag haml_tag_text('div option', attribute, options) do
      yield
    end
  end

  def fieldset attribute, options={}
    options.delete(:id) unless options[:id].present?
    @template.haml_tag haml_tag_text('fieldset', attribute, options) do
      yield
    end
  end

  def error_for? attribute
    if @object.is_a?(Claim)
      subkey = "claim_#{attribute}_error"
      base_errors = error_message_for(:base)
      base_errors && base_errors.to_h.key?(subkey) && !base_errors.to_h[subkey].empty?
    else
      attribute_errors = error_message_for(attribute)
      attribute_errors && !attribute_errors.empty?
    end
  end

  def error_span attribute, options={}
    @template.surround(error_span_open_tag(options), "</span>".html_safe) do
      error_span_message(attribute)
    end
  end

  def error_id_for attribute
    "#{@object_name.to_s.tr('[]','_')}_#{attribute}_error".squeeze('_')
  end

  def id_for attribute, default=nil
    error_for?(attribute) ? error_id_for(attribute) : (default || '')
  end

  def labelled_check_box attribute, label, yes='Yes', no='No', options={}
    set_class_and_id attribute, options
    hidden_input = check_box_input_hidden attribute, options, yes, no

    labeled_input = label(attribute) do
      check_box_input(attribute, options, yes, no) + label
    end

    list = [hidden_input]

    if error_for?(attribute)
      id = error_id_for(attribute)
      labeled_input.sub!(%Q[id="#{id}"], %Q[id="#{id.sub('_error','')}"])
      list << hidden_fullstop(options)
      list << error_span(attribute)
    end

    list << labeled_input

    list.join("\n").html_safe
  end

  def set_class_and_id attribute, options
    options[:class] = css_for(attribute, options)
    options[:id] = id_for(attribute) unless id_for(attribute).blank?
  end

  def label_for attribute, label, options={}
    label ||= attribute.to_s.humanize
    label = ["#{label}"]
    label << "<span class='hint block'#{aria_hidden(options)}>#{options[:hint]}</span>".html_safe if options[:hint]
    if error_for?(attribute)
      last = label.pop
      label << ( ends_with_punctuation?(last) ? last : (last + hidden_fullstop(options)) )
      label << error_span(attribute, options)
    end
    label.join(" ").html_safe
  end

  def ends_with_punctuation? span
    span[/\?<\/span/] || span[/\.<\/span>/]
  end

  def fieldset_tag(attribute, legend, options = {}, &block)
    fieldset = tag(:fieldset, options_for_fieldset(options), true)

    # use visually hidden legend for screen reader accessibility
    fieldset.safe_concat content_tag(:legend, legend, class: 'visuallyhidden') unless legend.blank?

    # hide repeated legend text from screen readers using aria-hidden='true'
    label = label_for(attribute, "<span aria-hidden='true'>#{legend}</span>".html_safe, hint: options.delete(:hint), aria_hidden: true)
    fieldset.safe_concat content_tag(:div, label) unless label.blank?

    fieldset.concat(capture(&block)) if block_given?
    fieldset.safe_concat("</fieldset>")
  end

  private

  def hidden_fullstop options
    '<span class="visuallyhidden">.</span>'.html_safe unless options[:aria_hidden]
  end

  def error_span_message attribute
    if @object.is_a? Claim
      error_message_for(:base).to_h["claim_#{attribute}_error"]
    else
      error_message_for(attribute)[0]
    end
  end

  def error_span_open_tag options
    " <span class='error#{error_classes(options)}'#{error_span_id(options)}#{aria_hidden(options)}>".html_safe
  end

  def error_span_id options
    options.has_key?(:id)? " id='#{options[:id]}'" : nil
  end

  def error_classes options
    ' visuallyhidden' if options[:hidden]
  end

  def aria_hidden options
    ' aria-hidden="true"' if options[:aria_hidden]
  end

  def options_for_fieldset options
    options.delete(:class) if options[:class].blank?
    options = {}.merge(options)
    options.delete(:hint)
    options.delete(:choice)
    options.delete(:date_select_options)
    options
  end

  def error_message_for symbol
    @object.errors.messages[symbol]
  end

  def check_box_input attribute, options, yes, no
    html = check_box(attribute, options, yes, no)
    html.gsub!(/<[^<]*type="hidden"[^>]*>/,'')
    html.html_safe
  end

  def check_box_input_hidden attribute, options, yes, no
    html = check_box(attribute, options, yes, no)
    html.gsub!(/.*(<[^<]*type="hidden"[^>]*>).*/, '\1')
    html.html_safe
  end

  def radio_button_row attribute, label, choice, virtual_pageview, input_class
    options = {}
    options.merge!(class: input_class) if input_class
    options.merge!(data: { 'virtual_pageview' => virtual_pageview }) if virtual_pageview

    input = radio_button(attribute, choice, options)

    id = input[/id="([^"]+)"/,1]

    @template.surround("<div class='option'>".html_safe, "</div>".html_safe) do
      @template.surround("<label for='#{id}'>".html_safe, "</label>".html_safe) do
        # errors = error_span(attribute, {hidden: true}) if error_for?(attribute)
        [
          # errors,
          input,
          label
        ].compact.join("\n")
      end
    end

  end

  def css_for attribute, options
    css = ''
    css += " #{options[:class]}" if options[:class].present?
    css += ' error' if error_for?(attribute)
    css.strip
  end

  def haml_tag_text tag, attribute, options
    tag += " #{css_for(attribute, options)}"
    haml_tag_text = tag.squeeze(' ').strip.gsub(' ','.')
  end

  def row_input attribute, input, options
    virtual_pageview = options[:data] ? options[:data].delete('virtual-pageview') : nil

    css = "row #{css_for(attribute, options)}".strip

    id = id_for(attribute).blank? ? '' : "id='#{id_for(attribute)}' "

    @template.surround("<div #{id}class='#{css}'>".html_safe, "</div>".html_safe) do
      input_options = options.merge(class: options[:input_class])
      input_options.merge!(data: {'virtual_pageview' => virtual_pageview}) if virtual_pageview
      input_options.delete(:label)
      input_options.delete(:input_class)

      labelled_input attribute, input, input_options, options[:label]
    end
  end

  def labelled_input attribute, input, input_options, label=nil
    label = label(attribute, label_for(attribute, label))

    if max_length = max_length(attribute)
      input_options.merge!(maxlength: max_length)
    end

    value = send(input, attribute, input_options)

    [ label, value ].join("\n").html_safe
  end

  def max_length attribute
    if validator = validators(attribute).detect{|x| x.is_a?(ActiveModel::Validations::LengthValidator)}
      validator.options[:maximum]
    end
  end

  def validators attribute
    @object.class.validators_on(attribute)
  end

end
