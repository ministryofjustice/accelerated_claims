root = exports ? this

PostcodeLookup =

  lookup: (postcode, view) ->
    console.log window.location.pathname
    separator = "/"
    if window.location.pathname.match(/\/$/)
      console.log "ends with a slash"
      separator = ""
    else
      console.log "doesn't end with a slash"


    myUrl =  window.location.pathname + separator + "postcode.json?pc=#{ encodeURI(postcode) }"
    console.log myUrl
    jQuery.ajax( myUrl,
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
