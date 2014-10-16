
def fill_in_value element, id, value
  find(:xpath, "/html/body//#{element}[@id='#{id}']").set value
end

def fill_text_field id, value
  fill_in_value 'input', id, value
end

def fill_text_area id, value
  fill_in_value 'textarea', id, value
end

