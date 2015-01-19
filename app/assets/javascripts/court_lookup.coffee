root = exports ? this

CourtLookup =

  lookup: (postcode, view) ->
    separator = "/"
    if window.location.pathname.match(/\/$/)
      separator = ""

    myUrl =  window.location.pathname + separator + "court-address/#{postcode}"
    jQuery.ajax( myUrl,
      success: (data) ->
        view.courtData = data
        view.populateCourtDetails()
      error: (jqXHR, textStatus, errorThrown) ->
        view.displayNoResultsFound()
    )

root.CourtLookup = CourtLookup
