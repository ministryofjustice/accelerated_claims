root = exports ? this

class CourtDetails
  instance = null

  constructor: ->
    if instance
      return instance
    else
      instance = this

root.CourtDetails = CourtDetails

jQuery ->
  new root.CourtDetails()
