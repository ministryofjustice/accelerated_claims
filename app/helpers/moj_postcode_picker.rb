class MojPostcodePicker


  def initialize(form, postcode_attr, address_attr, options = {})
    @form          = form
    @postcode_attr = postcode_attr
    @address_attr  = address_attr
    @options       = options
  end
  


  def emit
    html = File.open("#{Rails.root}/config/postcode_picker.html", "r") do |fp|
      fp.read
    end
    html.html_safe
  end



end