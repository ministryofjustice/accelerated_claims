require 'erb'
class MojPostcodePicker


  TEMPLATE_FILE = "#{Rails.root}/app/views/shared/_postcode_picker.html.haml"
  @@haml        = nil



  # instantiates a MojPostcodePicker object
  #
  # @param form[ActionView::Helpers::FormBuilder] - the form builder object which is to consume the html
  # @param prefix[String] - the prefix to be prepended to field names and attribute names
  # @param options[Hash] - a hash of options to configure the MojPostcodePicker if defaults aren't to be used:
  #   :name_prefix - the name prefix to be used, if not formed from the prefix, i.e. prefix "claim_property" generates a name prefix of "claim[property]"
  #   :postcode_attr - the name of the postcode attribute to be used if not 'postcode'
  #   :address_attr - the name of the address attribute to the used if not 'address_lines'
  #
  # e.g. MojPostcodePicker.new(form, 'claim_property', address_attr: 'street')
  #
  def initialize(form, prefix, options = {})
    @form          = form
    @prefix        = prefix
    @name_prefix   = options[:name_prefix] || generate_name_prefix
    @postcode_attr = options[:postcode_attr] || 'postcode'
    @address_attr  = options[:address_attr] || 'address_lines'
    @@haml         = load_haml if @@haml.nil?
  end
  
  def haml
    @@haml
  end


  def emit
    engine = Haml::Engine.new(@@haml)
    engine.render(binding)
  end



  private


  def generate_name_prefix
    parts = @prefix.split('_')
    name = parts.shift
    while parts.size > 0
      name += "[" + parts.shift + "]"
    end
    name
  end


  def load_haml
    if @@haml.nil?
      @@haml = File.open(TEMPLATE_FILE, "r") { |fp| fp.read }
    end
  end


end
















# require 'erb'
# class DummyController
#   def index
#     @name = 'Rasmus'
#   end
#   def get_binding # this is only a helper method to access the objects binding method
#     binding
#   end
# end

# controller = DummyController.new
# controller.index
# template_string = "Welcome <%= @name %>" # this string would typically be read from a template file
# template = ERB.new template_string
# puts template.result(controller.get_binding) # prints "Welcome Rasmus"



