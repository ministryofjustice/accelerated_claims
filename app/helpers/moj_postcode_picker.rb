require 'erb'
class MojPostcodePicker

  TEMPLATE_FILE   = "#{Rails.root}/app/helpers/templates/postcode_picker_template.haml"
  @@haml          = nil
  @@valid_opions = [:prefix, :name, :postcode_attr, :address_attr]

  # instantiates a MojPostcodePicker object
  #
  # @param form[ActionView::Helpers::FormBuilder] - the form builder object which is to consume the html
  # @param options[Hash] - a hash of options to configure the MojPostcodePicker if defaults aren't to be used:
  #   :prefix - the prefix to be added to be prepended to the field ids and names
  #   :name - the name to be used for the address field; if blank, the prefix is used with underscores transfored to square_bracketted names
  #   :postcode_attr - the name of the postcode attribute to be used if not 'postcode'
  #   :address_attr - the name of the address attribute to the used if not 'address_lines'
  #   :button_label - the Text to use on the Find UK Address button if not "Find UK Address"
  #
  # e.g. Given a form for a Property object:
  #   MojPostcodePicker.new(form, prefix: 'claim_property', address_attr: 'street')                 # generates an id of 'claim_property_street' and a name of 'claim[property][street]'
  #   MojPostcodePicker.new(form, prefix: 'claim_defendant_2')                                      # generates an id of 'claim_defendant_2_street, and a name of claim[defendant][2][street]'
  #   MojPostcodePicker.new(form, prefix: 'claim_defendant_2', name_prefix: 'claim[defendant_2'])   # generates an id of 'claim_defendant_2_street, and a name of claim[defendant_2][street]'
  #   MojPostcodePicker.new(form, nil, name: 'address')                                             # generates an id of 'address_lines and a name of 'address'
  #   MojPostcodePicker.new(form, prefix: 'claim_property', vc: 'england+wales'
  #
  #
  def initialize(form, options)
    @form            = form
    @options         = options
    @prefix          = options[:prefix]
    @valid_countries = options[:vc] || 'all'
    @name            = generate_name
    @postcode_attr   = options[:postcode_attr] || 'postcode'
    @address_attr    = options[:address_attr] || 'address_lines'
    @street_hint     = options[:street_hint] || ''
    @button_label    = options[:button_label] || 'Find UK address'
    @@haml           = load_haml if @@haml.nil? || Rails.env.development?
    @postcode_value  = form.object.send(@postcode_attr.to_sym)
    @address_value   = form.object.send(@address_attr.to_sym)
    @address_value.gsub!("\r\n", "&#x000A;") unless @address_value.nil?
    @hide            = options[:hide] || false
    @nonjs_optional  = options[:nonjs_optional] || false
  end

  def haml
    @@haml
  end

  def emit
    engine = Haml::Engine.new(@@haml)
    engine.render(binding)
  end

  def country_name_for_messages
    CountryNameNormalizer.new(@options).to_sentence
  end

  private

  def generate_name
    name = nil
    if @options.key?(:name)
      name = @options[:name]
    else
      parts = @prefix.split('_')
      name = parts.shift
      while parts.size > 0
        name += "[" + parts.shift + "]"
      end

    end
    name
  end

  def load_haml
    @@haml = File.open(TEMPLATE_FILE, "r") { |fp| fp.read }
  end

end

