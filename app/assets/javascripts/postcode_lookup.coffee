root = exports ? this

PostcodeLookup =

  lookup: (postcode, country, view) ->
    separator = "/"
    if window.location.pathname.match(/\/$/)
      separator = ""


    myUrl =  window.location.pathname + separator + "postcode.json?pc=#{ encodeURI(postcode) }&vc=#{encodeURI(country)}"
    jQuery.ajax( myUrl,
      success: (data) ->
        view.handleSuccessfulResponse(data)
      statusCode:
        422: ->
          view.displayInvalidPostcodeMessage()
        404: ->
          view.displayNoResultsFound()
        503: ->
          view.displayServiceUnavailable()
    )

root.PostcodeLookup = PostcodeLookup
