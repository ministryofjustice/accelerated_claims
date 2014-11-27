
def fill_in_value element, id, value
  find(:xpath, "/html/body//#{element}[@id='#{id}']").set value
end

def fill_text_field id, value
  fill_in_value 'input', id, value
end

def fill_text_area id, value
  fill_in_value 'textarea', id, value
end

def validation_error_text page
  error_messages = page.all('.error-summary li')
  if error_messages.size > 0
    errors = ["Expected successful claim submission, instead these validation errors were returned:"]
    error_messages.each { |li| errors << "#{li.text}: #{li.find('a')['href']}" }
    errors.join("\n\t")
  else
    nil
  end
end
