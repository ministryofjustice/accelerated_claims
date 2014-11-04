root = exports ? this

PostcodeLookup =

  lookup: (postcode, view) ->
    separator = "/"
    if window.location.pathname.match(/\/$/)
      separator = ""


    myUrl =  window.location.pathname + separator + "postcode.json?pc=#{ encodeURI(postcode) }"
    jQuery.ajax( myUrl,
      success: (data) ->
        view.displayAddresses(data)
      statusCode:
        422: ->
          view.displayInvalidPostcodeMessage()
        404: (data) ->
          view.displayNoResultsFound(data)
        503: ->
          view.displayServiceUnavailable()
    )

root.PostcodeLookup = PostcodeLookup
