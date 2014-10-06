
findCourtName = (postcode) ->
  url = '/court-address/' + postcode
  jQuery.ajax url,
    type: 'GET'
    success: (data) ->
      console.log 'data returned is: ' + data[0]
      court_name_element = document.getElementById('court-name')
      court_name_element.innerHTML = '<b>' + data[0].name + '</b>'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log 'ERROR:' + textStatus

$ ->
  $('#claim_property_postcode').bind 'blur', ->
    postcode = document.getElementById('claim_property_postcode')
    findCourtName postcode.value
