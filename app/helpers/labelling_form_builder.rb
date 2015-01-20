
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

  # produces an postcode picker widget - this will produce an address/street and postcode attributes for the given object type
  # @param [String] attribute: the name of the attribute on Claim which is to have the street and postcode attributes (e.g. property, defendant_1)
  # @param [Hash] options: options to control the way in which the potcode picker is displayed, and what html is generated in the form:
  #  :prefix - the prefix to be applied to each element in the form
  #  :postcode_attr - the name of the postcode attribute if not 'postcode'
  #  :address_attr - the name of the address attribute if not 'street'
  #  :name - the prefix of the name given to the street and postcode attributes if not 'claim['xxxx'] where xxxx is the attribute
  #  :street_hint -  and html which is to be inserted as a hint above the street textarea
  #  :vc - list of valid countries: postcodes that return a country not in the supplied list will be marked as invalid.
  #        If not supplied or blank, all countries are valid.  Countries should be joined by '+' and spaces in country names should be replaced
  #        by underscores, e.g "england+wales+channel_islands+isle_of_man"
  #  :button_label - the text to use on the Find UK Address button if not 'Find Uk Address'
  #
  def moj_postcode_picker attribute, options = {}
    default_options = {
      :prefix        => "claim_#{attribute}",
      :postcode_attr => :postcode,
      :address_attr  => :street,
      :name          => "claim[#{attribute}]"
    }
    options = default_options.merge(options)
    mpp = MojPostcodePicker.new(self, options)
    mpp.emit
  end

  # Defaults to "Yes" "No" labels on radio inputs
  def radio_button_fieldset attribute, legend, options={}
    translation_key = translation_key(attribute)
    raise "TBD: #{translation_key} #{options[:choice]}" if options[:choice].is_a?(Hash)

    virtual_pageview = get_virtual_pageview(options)
    input_class = options.delete(:input_class)

    set_class_and_id attribute, options

    options[:choice] ||= [ 'Yes', 'No' ]

    options_class = get_class(options)
    data_reverse = get_data_reverse(options)

    fieldset_tag attribute, legend, options do
      @template.surround("<div class='#{options_class}'#{data_reverse}>".html_safe, "</div>".html_safe) do
        options[:choice].map do |choice|
          radio_button_row(attribute, choice, virtual_pageview, input_class)
        end.join("\n")
      end
    end
  end

  def row attribute, options={}
    @template.haml_tag haml_tag_text('div option', attribute, options) do
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

  # Creates key for lookup of translation text.
  # E.g. translation_key(hearing, {:choice=>"No"}) when in possession form
  #      returns "claim.possession.hearing.no"
  def translation_key attribute, options={}
    key = "#{ parent_id.gsub('_','.') }.#{attribute}".squeeze('.')
    key.gsub!(/\.\d+\./, '.')
    if choice = options[:choice]
      choice = 'na' if choice == ''
      key += ".#{choice.downcase}"
    end
    key
  end

  def error_id_for attribute
    field_id = "#{parent_id}_#{attribute}".squeeze('_')
    "#{field_id}_error"
  end

  def parent_id
    @object_name.to_s.tr('[]','_').squeeze('_')
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

  def fieldset_tag(attribute, legend_text, options = {}, &block)
    fieldset = tag(:fieldset, options_for_fieldset(options), true)

    fieldset.safe_concat legend_for(attribute, legend_text, options) unless legend_text.blank?

    fieldset.concat(capture(&block)) if block_given?
    fieldset.safe_concat("</fieldset>")
  end

  private

  def get_data_reverse(options)
    options.delete(:toggle_fieldset) ? ' data-reverse="true"' : ''
  end

  def get_class(options)
    options[:class][/inline/] ? 'inline' : 'options'
  end

  def fieldset attribute, options={}
    options.delete(:id) unless options[:id].present?
    @template.haml_tag haml_tag_text('fieldset', attribute, options) do
      yield
    end
  end

  def id_for attribute, default=nil
    error_for?(attribute) ? error_id_for(attribute) : (default || '')
  end

  def label_content_for attribute, label, options={}
    label ||= attribute.to_s.humanize
    label = ["#{label}"]
    hint = hint_span(options)
    label << hint if hint
    if error_for?(attribute)
      last = label.pop
      label << ( ends_with_punctuation?(last) ? last : (last + hidden_fullstop(options)) )
      label << error_span(attribute, options)
    end
    label.join(" ").html_safe
  end

  def hint_span options
    options[:hint] ? "<span class='hint block'>#{options[:hint]}</span>".html_safe : nil
  end

  def ends_with_punctuation? span
    span[/\?<\/span/] || span[/\.<\/span>/] || span[/\.|\?$/]
  end

  def legend_for attribute, legend_text, options
    label = label_content_for(attribute, legend_text, hint: options[:hint])
    content_tag(:legend, label)
  end

  def hidden_fullstop options
    '<span class="visuallyhidden">.</span>'.html_safe
  end

  def error_span_message attribute
    if @object.is_a? Claim
      error_message_for(:base).to_h["claim_#{attribute}_error"]
    else
      error_message_for(attribute)[0]
    end
  end

  def error_span_open_tag options
    " <span class='error#{error_classes(options)}'#{error_span_id(options)}>".html_safe
  end

  def error_span_id options
    options.has_key?(:id)? " id='#{options[:id]}'" : nil
  end

  def error_classes options
    ' visuallyhidden' if options[:hidden]
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

  def radio_button_row attribute, choice, virtual_pageview, input_class
    translation_key = translation_key(attribute, choice: choice)

    translation = I18n.t(translation_key)
    raise "translation missing: #{translation_key}" if translation[/translation missing/]
    label = translation unless translation[/translation missing/]

    options = {}
    options.merge!(class: input_class) if input_class
    options.merge!(data: { 'virtual_pageview' => virtual_pageview }) if virtual_pageview

    input = radio_button(attribute, choice, options)

    id = input[/id="([^"]+)"/,1]

    @template.surround("<div class='option'>".html_safe, "</div>".html_safe) do
      @template.surround("<label for='#{id}'>".html_safe, "</label>".html_safe) do
        [
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
    virtual_pageview = get_virtual_pageview(options)
    css = "form-group #{css_for(attribute, options)}".strip
    id = id_for(attribute).blank? ? '' : "id='#{id_for(attribute)}' "

    @template.surround("<div #{id}class='#{css}'>".html_safe, "</div>".html_safe) do
      input_options = options.merge(class: options[:input_class])
      input_options.merge!(data: {'virtual_pageview' => virtual_pageview}) if virtual_pageview
      input_options.delete(:label)
      input_options.delete(:input_class)

      labelled_input attribute, input, input_options, options[:label]
    end
  end

  def get_virtual_pageview(options)
    options[:data] ? options[:data].delete('virtual-pageview') : nil
  end

  def labelled_input attribute, input, input_options, label=nil
    label = label(attribute, label_content_for(attribute, label))

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
