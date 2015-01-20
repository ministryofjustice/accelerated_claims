root = exports ? this

addExternalAltText = ->
  $("a[target='_blank']").attr('alt', 'External link, opens in new window')

jQuery ->
  addExternalAltText()