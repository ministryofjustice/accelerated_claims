root = exports ? this

addExternalAltText = ->
  $("a[target='_blank']").attr('title', 'External link, opens in new window')

jQuery ->
  addExternalAltText()