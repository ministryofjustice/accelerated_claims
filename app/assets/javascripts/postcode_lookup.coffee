root = exports ? this

PostcodeLookup =

  lookup: (postcode, view) ->
    jQuery.ajax(
      url: "/postcode.json?pc=#{ encodeURI(postcode) }",
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
