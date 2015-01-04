root = exports ? this

CourtLookup =

  lookup: (postcode, view) ->
    separator = "/"
    if window.location.pathname.match(/\/$/)
      separator = ""

    myUrl =  window.location.pathname + separator + "court-address/#{postcode}"
    jQuery.ajax( myUrl,
      success: (data) ->
        court = new CourtDetails
        court.details = data
        console.log "data is: #{data}"
        console.log "data given is: #{court.details}"
        # view.populateCourtDetails(data)
        view.populateCourtDetails()
      error: (jqXHR, textStatus, errorThrown) ->
        view.displayNoResultsFound()
    )

root.CourtLookup = CourtLookup
