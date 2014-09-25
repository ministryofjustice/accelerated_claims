root = exports ? this

PostcodeLookup =

  lookup: (postcode, view) ->
    jQuery.ajax(
      url: 'http://localhost:3000/postcode.json?pc=SW106LV',
      success: (data) ->
        view.displayAddresses(data)
      statusCode:
        422: ->
          view.displayInvalidPostcodeMessage()
        404: ->
          view.displayNoResultsFound()
        503: ->
          view.displayServiceUnavailable()
    )

root.PostcodeLookup = PostcodeLookup
