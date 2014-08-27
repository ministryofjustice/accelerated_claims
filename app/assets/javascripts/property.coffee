$("#claim_property_house_no").on "change", (event) ->
  field = $('#room_number')
  checked = $(this).is(':checked')
  field.toggleClass ->
    'toggle-hint'
